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
end
