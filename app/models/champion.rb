class Champion < ActiveRecord::Base
  validates :riot_id, presence: true, numericality: { only_integer: true }
  validates :name, presence: true

  has_many :champion_matches
  has_one :champion_api_data

  def self.find_by_lower_name(name)
    where('lower(name) = lower(?)', name)
  end
end
