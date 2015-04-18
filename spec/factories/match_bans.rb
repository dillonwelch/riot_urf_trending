FactoryGirl.define do
  factory :match_ban do
    champion
    match
    sequence(:team_id) { |n| n }
    sequence(:pick_turn) { |n| n }
  end
end
