FactoryGirl.define do
  factory :champion do
     sequence(:riot_id)
     sequence(:name)    { |n| "Champion #{n}" }
     primary_role       { |n| "Role #{n}" }
     secondary_role     { |n| "Role #{n}" }

     factory :champion_with_raw_api_data do
       transient do
         raw_api_data {}.to_json
       end

       after(:create) do |champion, evaluator|
         create(:champion_api_data,
                champion: champion,
                raw_api_data: evaluator.raw_api_data)
       end
     end
  end
end
