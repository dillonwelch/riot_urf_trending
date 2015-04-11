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

  describe '.find_by_lower_name' do
    let!(:champion) { create(:champion, name: 'Amumu') }

    it 'finds the exact name' do
      expect(Champion.find_by_lower_name('Amumu')).to eq [champion]
    end

    it 'finds the all lower case name' do
      expect(Champion.find_by_lower_name('amumu')).to eq [champion]
    end

    it 'finds the all upper case name' do
      expect(Champion.find_by_lower_name('AMUMU')).to eq [champion]
    end

    it 'does not find with the wrong name' do
      expect(Champion.find_by_lower_name('Amumu!')).to eq []
    end
  end
end
