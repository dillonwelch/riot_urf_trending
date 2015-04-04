RSpec.describe ChampionApiData do
  it { expect(subject).to validate_presence_of(:champion) }
  it { expect(subject).to belong_to(:champion) }
  it { expect(subject).to have_db_index(:champion_id) }
end
