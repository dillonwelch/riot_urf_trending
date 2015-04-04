RSpec.describe Champion do
  it { expect(subject).to validate_presence_of(:riot_id) }
  it { expect(subject).to validate_numericality_of(:riot_id).only_integer }
  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to have_many(:champion_matches) }
  it { expect(subject).to have_one(:champion_api_data) }
  it { expect(subject).to have_db_index(:name) }
  it { expect(subject).to have_db_index(:riot_id) }
  it { expect(subject).to have_db_index(:primary_role) }
  it { expect(subject).to have_db_index(:secondary_role) }
end
