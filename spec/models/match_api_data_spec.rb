RSpec.describe MatchApiData do
  it { expect(subject).to validate_presence_of(:match) }
  it { expect(subject).to belong_to(:match) }
  it { expect(subject).to have_db_index(:match_id) }
end
