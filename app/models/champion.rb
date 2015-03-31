class Champion < ActiveRecord::Base
  validates :riot_id, presence: true, numericality: { only_integer: true }
  validates :name, presence: true
end
