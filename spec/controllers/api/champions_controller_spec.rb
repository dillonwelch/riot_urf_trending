RSpec.describe Api::ChampionsController do
  describe 'GET :total_kills' do
    let(:count) { 2 }

    before do
      count.times do
        create(:champion_match, kills: 3)
      end
    end

    it 'returns the total amount of kills' do
      get :total_kills
      expect(response.body).to eq "6"
    end
  end

  describe 'GET :total_deaths' do
    let(:count) { 2 }

    before do
      count.times do
        create(:champion_match, deaths: 3)
      end
    end

    it 'returns the total amount of deaths' do
      get :total_deaths
      expect(response.body).to eq "6"
    end
  end

  describe 'GET :kills' do
    let(:count)    { 2 }
    let(:champion) { create(:champion) }
    let(:other)    { create(:champion) }

    before do
      count.times do
        create(:champion_match, champion: champion, kills: 3)
      end

      create(:champion_match, champion: other, kills: 4)
    end

    it 'returns the total amount of kills for the champion' do
      get :kills, name: champion.name
      expect(response.body).to eq "6"
    end
  end

  describe 'GET :deaths' do
    let(:count)    { 2 }
    let(:champion) { create(:champion) }
    let(:other)    { create(:champion) }

    before do
      count.times do
        create(:champion_match, champion: champion, deaths: 3)
      end

      create(:champion_match, champion: other, deaths: 4)
    end

    it 'returns the total amount of deaths for the champion' do
      get :deaths, name: champion.name
      expect(response.body).to eq "6"
    end
  end
end
