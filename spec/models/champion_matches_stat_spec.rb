RSpec.describe ChampionMatchesStat do
  it { expect(subject).to validate_presence_of(:kills) }
  it { expect(subject).to validate_numericality_of(:kills).only_integer }
  it { expect(subject).to validate_presence_of(:deaths) }
  it { expect(subject).to validate_numericality_of(:deaths).only_integer }
  it { expect(subject).to validate_presence_of(:assists) }
  it { expect(subject).to validate_numericality_of(:assists).only_integer }
  it { expect(subject).to belong_to(:champion) }
  it { expect(subject).to validate_presence_of(:champion) }
  it { expect(subject).to delegate_method(:riot_id).to(:champion) }
  it { expect(subject).to validate_presence_of(:start_time) }
end
