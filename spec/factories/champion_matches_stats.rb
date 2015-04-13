FactoryGirl.define do
  factory :champion_matches_stat do
    champion
    victories  { rand(100) }
    losses     { rand(100) }
    kills      { rand(100) }
    deaths     { rand(100) }
    assists    { rand(100) }
    start_time { (Time.zone.now - 5.minutes).to_i * 1000 }
  end
end
