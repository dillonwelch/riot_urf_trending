class MatchBan < ActiveRecord::Base
  include ChampionMatchJoinTable

  validates :team_id, presence: true, numericality: { only_integer: true }
  validates :pick_turn, presence: true, numericality: { only_integer: true }
end
