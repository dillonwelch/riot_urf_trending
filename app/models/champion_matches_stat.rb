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

  def self.overall_for_champion(champion)
    select('
      (sum(victories)::float / (case sum(victories + losses) when 0 then 1 else sum(victories + losses) end )) * 100 as win_rate,
      case sum(total_picks)
        when 0 then 0
        else sum(victories + losses)::float / sum(total_picks) * 100
      end as pick_rate,
      sum(victories) as total_victories,
      sum(losses) as total_losses,
      extract(month from to_timestamp(champion_matches_stats.start_time / 1000)) as month,
      extract(day from to_timestamp(champion_matches_stats.start_time / 1000)) as day
    ').joins('
      inner join (
        select sum(victories + losses) as total_picks, start_time
        from champion_matches_stats
        group by start_time
      ) as pick_rate_table on pick_rate_table.start_time =
                              champion_matches_stats.start_time'
    ).joins(:champion).where(champion_id: champion.id).
    group('champion_matches_stats.champion_id, name, month, day').
    reorder('month, day')
  end
end
