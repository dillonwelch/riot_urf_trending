module ModelHelpers
  RSpec::Matchers.define :have_champion_match_join_table_concern do
    match do |actual|
      actual.class.included_modules.include? ChampionMatchJoinTable
    end
  end
end
