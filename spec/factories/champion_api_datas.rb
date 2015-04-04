FactoryGirl.define do
  factory :champion_api_data do
    raw_api_data {}.to_json
    champion
  end
end
