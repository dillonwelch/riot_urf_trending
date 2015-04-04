FactoryGirl.define do
  factory :match_api_data do
    raw_api_data {}.to_json
    match
  end
end
