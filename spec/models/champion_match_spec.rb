RSpec.describe ChampionMatch do
  it { expect(subject).to validate_presence_of(:kills) }
  it { expect(subject).to validate_numericality_of(:kills).only_integer }
  it { expect(subject).to validate_presence_of(:deaths) }
  it { expect(subject).to validate_numericality_of(:deaths).only_integer }
  it { expect(subject).to validate_presence_of(:assists) }
  it { expect(subject).to validate_numericality_of(:assists).only_integer }
  it { expect(subject).to belong_to(:champion) }
  it { expect(subject).to validate_presence_of(:champion) }
  it { expect(subject).to belong_to(:match) }
  it { expect(subject).to validate_presence_of(:match) }
  it { expect(subject).to delegate_method(:game_id).to(:match) }
  it { expect(subject).to delegate_method(:riot_id).to(:champion) }

  # TODO
  # set up factories
  # find_by_game_id
  # find_by_riot_id
  # wins_and_losses
  # n_best
end
