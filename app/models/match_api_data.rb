class MatchApiData < ActiveRecord::Base
  belongs_to :match
  validates :match, presence: true
end
