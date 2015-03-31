class ChampionMatch < ActiveRecord::Base
  belongs_to :champion
  validates :champion, presence: true

  belongs_to :match
  validates :match, presence: true

  validates :victory, presence: true

  def self.find_by_game_id(game_id)
    joins(:match).where(matches: { game_id: game_id } )
  end
end
