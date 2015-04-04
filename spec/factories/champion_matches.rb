FactoryGirl.define do
  factory :champion_match do
    kills   { rand(100) }
    deaths  { rand(100) }
    assists { rand(100) }
    victory { [true, false].sample }
    champion
    match
  end
end
