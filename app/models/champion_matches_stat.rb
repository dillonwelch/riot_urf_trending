class ChampionMatchesStat < ActiveRecord::Base
  belongs_to :champion
  validates :champion, presence: true

  validates :victories, presence: true, numericality: { only_integer: true }
  validates :losses, presence: true, numericality: { only_integer: true }
  validates :kills, presence: true, numericality: { only_integer: true }
  validates :deaths, presence: true, numericality: { only_integer: true }
  validates :assists, presence: true, numericality: { only_integer: true }

  validates :start_time, presence: true

  delegate :riot_id, to: :champion

  def self.all_champion_stats
    select(
      '(sum(victories)::float / sum(victories + losses)) * 100 as win_rate,
      sum(victories + losses)::float / (
        select sum(victories + losses) from champion_matches_stats
      ) * 1000 as pick_rate,
      sum(victories + losses) as total_picks'
    ).joins(:champion)
  end

  def self.individual_stats
    select(
      '(sum(victories)::float / sum(victories + losses)) * 100 as win_rate,
      sum(victories + losses)::float / (
        select sum(victories + losses) from champion_matches_stats
      ) * 1000 as pick_rate,
      sum(victories + losses) as total_picks,
      sum(kills)::float / sum(victories + losses) as per_game_kills,
      sum(deaths)::float / sum(victories + losses) as per_game_deaths,
      sum(assists)::float / sum(victories + losses) as per_game_assists,

      (
        select sum(kills)::float /
          ( select sum(victories + losses) from champion_matches_stats )
        from champion_matches_stats
      ) as average_kills,
      (
        select sum(deaths)::float /
          ( select sum(victories + losses) from champion_matches_stats )
        from champion_matches_stats
      ) as average_deaths,
      (
        select sum(assists)::float /
          ( select sum(victories + losses) from champion_matches_stats )
        from champion_matches_stats
      ) as average_assists'
    ).reorder('')
  end

  def self.individual_champion_stats(champion)
    individual_stats.joins(:champion).where(champion_id: champion.id).
      select('champion_id, name').group(:champion_id, :name).first
  end

  def self.individual_role_stats(role)
    individual_stats.joins(:champion).where('primary_role = ?', role).
      select(:primary_role).group(:primary_role).first
  end

  def self.overall
    select('
      (sum(victories)::float / (
        case sum(victories + losses)
          when 0 then 1
          else sum(victories + losses)
        end )
      ) * 100 as win_rate,
      case sum(total_picks)
        when 0 then 0
        else sum(victories + losses)::float / sum(total_picks) * 1000
      end as pick_rate,
      sum(victories) as total_victories,
      sum(losses) as total_losses,
      extract(month from to_timestamp(champion_matches_stats.start_time / 1000))
        as month,
      extract(day from to_timestamp(champion_matches_stats.start_time / 1000))
        as day
    ').joins('
      inner join (
        select sum(victories + losses) as total_picks, start_time
        from champion_matches_stats
        group by start_time
        order by start_time
      ) as pick_rate_table on pick_rate_table.start_time =
                              champion_matches_stats.start_time'
    ).reorder('month, day')
  end

  def self.overall_for_champion(champion)
    overall.joins(:champion).where(champion_id: champion.id).
      group('champion_matches_stats.champion_id, month, day')
  end

  def self.overall_for_role(role)
    overall.joins(:champion).where('primary_role = ?', role).
      group('primary_role, month, day')
  end
end
