RSpec.describe MatchBan do
  it { expect(subject).to have_champion_match_join_table_concern }

  it { expect(subject).to validate_presence_of(:team_id) }
  it { expect(subject).to validate_numericality_of(:team_id).only_integer }
  it { expect(subject).to validate_presence_of(:pick_turn) }
  it { expect(subject).to validate_numericality_of(:pick_turn).only_integer }
end
