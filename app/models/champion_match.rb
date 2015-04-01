class ChampionMatch < ActiveRecord::Base
  belongs_to :champion
  validates :champion, presence: true

  belongs_to :match
  validates :match, presence: true

  validates :victory, inclusion: [true, false]

  delegate :game_id, to: :match
  delegate :riot_id, to: :champion

  def self.find_by_game_id(game_id)
    joins(:match).where(matches: { game_id: game_id })
  end

  def self.find_by_riot_id(riot_id)
    joins(:champion).where(champions: { riot_id: riot_id })
  end

  def self.all_wins_and_losses
    find_by_sql('
      select coalesce(victories, 0) as victories, coalesce(losses, 0) as losses, name
      from champion_matches
      left outer join (
          select count(victory) as losses, champion_id
          from champion_matches
          where victory = false
          group by champion_id
      ) as losses on losses.champion_id = champion_matches.champion_id
      left outer join (
          select count(victory) as victories, champion_id
          from champion_matches
          where victory = true
          group by champion_id
      ) as victories on victories.champion_id = champion_matches.champion_id
      right outer join champions on champion_matches.champion_id = champions.id
      group by name, victories, losses
      order by champions.name
    ')
  end
end
