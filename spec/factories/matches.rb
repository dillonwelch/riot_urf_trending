FactoryGirl.define do
  factory :match do
    sequence(:game_id)
    sequence(:region) { |n| "Region #{n}" }
    start_time        { (Time.zone.now - 5.minutes).to_i * 1000 }
    duration          { 300.seconds }

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

    factory :match_with_champion_matches do
      transient do
        count 10
      end

      after(:create) do |match, evaluator|
        create_list(:champion_match, evaluator.count, match: match)
      end
    end
  end
end
