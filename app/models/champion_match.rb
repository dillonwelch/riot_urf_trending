class ChampionMatch < ActiveRecord::Base
  belongs_to :champion
  validates :champion, presence: true

  belongs_to :match
  validates :match, presence: true

  validates :victory, inclusion: [true, false]

  validates :kills, presence: true, numericality: { only_integer: true }
  validates :deaths, presence: true, numericality: { only_integer: true }
  validates :assists, presence: true, numericality: { only_integer: true }

  delegate :game_id, to: :match
  delegate :riot_id, to: :champion

  def self.find_by_game_id(game_id)
    joins(:match).where(matches: { game_id: game_id })
  end

  def self.find_by_riot_id(riot_id)
    joins(:champion).where(champions: { riot_id: riot_id })
  end

  def self.all_losses(start_time=Time.zone.now - 5.minutes,
                      end_time=Time.zone.now)
    joins(
      sanitize_sql_array(
        [
          'left outer join (
             select count(victory) as losses, champion_id
             from champion_matches
             join matches on champion_matches.match_id = matches.id
             where victory = false
             and ( ( start_time + duration * 1000) >= :start_time )
             and ( ( start_time + duration * 1000) < :end_time )
             group by champion_id
           ) as losses on losses.champion_id = champion_matches.champion_id',
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
          'left outer join (
             select count(victory) as victories, champion_id
             from champion_matches
             join matches on champion_matches.match_id = matches.id
             where victory = true
             and ( ( start_time + duration * 1000) >= :start_time )
             and ( ( start_time + duration * 1000) < :end_time )
             group by champion_id
           ) as victories on
            victories.champion_id = champion_matches.champion_id',
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

  # def self.all_wins_and_losses(start_time=Time.zone.now - 6.days,
  #                              end_time=Time.zone.now)
  #   select('coalesce(victories, 0) as victories,
  #          coalesce(losses, 0) as losses, name').
  #     joins(:match).where(
  #       '( ( start_time + duration * 1000) >= :start_time )
  #        and ( ( start_time + duration * 1000) < :end_time )',
  #        start_time: start_time.to_i * 1000,
  #        end_time: end_time.to_i * 1000).
  #     wins_and_losses(start_time, end_time).
  #     group('name, victories, losses').
  #     order('name asc')
  # end

  # def self.n_most_played(n=5,
  #                        start_time=Time.zone.now - 6.days
  #                        end_time=Time.zone.now)
  #   select('coalesce(victories, 0) as victories,
  #           coalesce(losses, 0) as losses,
  #           name, coalesce((sum(victories + losses) /
  #                           count(name))::int, 0) as total').
  #     joins(:match).where(
  #       '( ( start_time + duration * 1000) >= :start_time )
  #        and ( ( start_time + duration * 1000) < :end_time )',
  #        start_time: start_time.to_i * 1000,
  #        end_time: end_time.to_i * 1000).
  #     wins_and_losses(start_time, end_time).
  #     group('name, victories, losses').
  #     order('total desc').
  #     limit(n)
  # end

  def self.n_best(n=5,
                  start_time=Time.zone.now - 6.days,
                  end_time=start_time + 1.hour)
    select('coalesce(victories, 0) as victories,
           coalesce(losses, 0) as losses,
           champion_matches.champion_id,
           coalesce((victories::float /
                     (victories + coalesce(losses, 0))), 0) as win_rate').
      joins(:match).where(
        '( ( start_time + duration * 1000) >= :start_time )
         and ( ( start_time + duration * 1000) < :end_time )',
        start_time: start_time.to_i * 1000,
        end_time: end_time.to_i * 1000).
      wins_and_losses(start_time, end_time).
      group('champion_matches.champion_id, victories, losses').
      order('win_rate desc, victories desc').limit(n)
  end
end
