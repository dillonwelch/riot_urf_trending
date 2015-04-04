FactoryGirl.define do
  factory :match do
    sequence(:game_id)
    sequence(:region) { |n| "Region #{n}" }

     factory :match_with_raw_api_data do
       transient do
         raw_api_data {}.to_json
       end

       after(:create) do |match, evaluator|
         create(:match_api_data,
                match: match,
                raw_api_data: evaluator.raw_api_data)
       end
     end
  end
end
