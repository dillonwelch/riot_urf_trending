class ChampionMatch < ActiveRecord::Base
  belongs_to :champion
  validates :champion, presence: true

  belongs_to :match
  validates :match, presence: true

  validates :victory, presence: true
end
