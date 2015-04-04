class ChampionApiData < ActiveRecord::Base
  belongs_to :champion
  validates :champion, presence: true
end
