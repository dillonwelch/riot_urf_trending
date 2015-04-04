RSpec.describe Match do
  it { expect(subject).to validate_presence_of(:game_id) }
  it { expect(subject).to have_many(:champion_matches) }
  it { expect(subject).to have_one(:match_api_data) }
  it { expect(subject).to have_db_index(%i(game_id region)) }
  it { expect(subject).to have_db_index(:region) }
end
