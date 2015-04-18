class ChampionMatch < ActiveRecord::Base
  include ChampionMatchJoinTable

  validates :victory, inclusion: [true, false]

  validates :kills, presence: true, numericality: { only_integer: true }
  validates :deaths, presence: true, numericality: { only_integer: true }
  validates :assists, presence: true, numericality: { only_integer: true }

  delegate :game_id, to: :match
  delegate :riot_id, to: :champion

  def self.all_count_join(victory, column)
    "select count(victory) as #{column}, champion_id
    from champion_matches
    join matches on champion_matches.match_id = matches.id
    where victory = #{victory}
    and ( ( start_time + duration * 1000) >= :start_time )
    and ( ( start_time + duration * 1000) < :end_time )
    group by champion_id"
  end

  def self.all_losses(start_time=Time.zone.now - 5.minutes,
                      end_time=Time.zone.now)
    joins(
      sanitize_sql_array(
        [
          "left outer join (
            #{all_count_join(false, 'losses')}
           ) as losses on losses.champion_id = champion_matches.champion_id",
          start_time: start_time.to_i * 1000,
          end_time: end_time.to_i * 1000
        ]
      )
    )
  end

  def self.all_wins(start_time=Time.zone.now - 5.minutes,
                    end_time=Time.zone.now)
    joins(
      sanitize_sql_array(
        [
          "left outer join (
            #{all_count_join(true, 'victories')}
           ) as victories on
            victories.champion_id = champion_matches.champion_id",
          start_time: start_time.to_i * 1000,
          end_time: end_time.to_i * 1000
        ]
      )
    )
  end

  def self.wins_and_losses(start_time=Time.zone.now - 6.days,
                           end_time=Time.zone.now)
    all_wins(start_time, end_time).all_losses(start_time, end_time)
  end

  def self.match_join(start_time, end_time)
    joins(:match).where(
      '( ( start_time + duration * 1000) >= :start_time )
       and ( ( start_time + duration * 1000) < :end_time )',
      start_time: start_time.to_i * 1000,
      end_time: end_time.to_i * 1000)
  end

  def self.n_best(n=5,
                  start_time=Time.zone.now - 6.days,
                  end_time=start_time + 1.hour)
    select('coalesce(victories, 0) as victories,
           coalesce(losses, 0) as losses,
           champion_matches.champion_id,
           coalesce((victories::float /
                     (victories + coalesce(losses, 0))), 0) as win_rate').
      match_join(start_time, end_time).
      wins_and_losses(start_time, end_time).
      group('champion_matches.champion_id, victories, losses').
      order('win_rate desc, victories desc').limit(n)
  end

  def self.n_best_with_kda(n=5,
                           start_time=Time.zone.now - 6.days,
                           end_time=start_time + 1.hour)
    select('sum(kills) as kills, sum(deaths) as deaths,
           sum(assists) as assists, champion_id').
      match_join(start_time, end_time).
      group('champion_id').order(:champion_id).limit(n)
  end
end
