class Match < ActiveRecord::Base
  validates :game_id, presence: true

  has_many :champion_matches
end
