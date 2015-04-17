class MatchBan < ActiveRecord::Base
  belongs_to :champion
  validates :champion, presence: true

  belongs_to :match
  validates :match, presence: true

  validates :team_id, presence: true, numericality: { only_integer: true }
  validates :pick_turn, presence: true, numericality: { only_integer: true }

  delegate :game_id, to: :match
  delegate :riot_id, to: :champion

  def self.find_by_game_id(game_id)
    joins(:match).where(matches: { game_id: game_id })
  end

  def self.find_by_riot_id(riot_id)
    joins(:champion).where(champions: { riot_id: riot_id })
  end
end
