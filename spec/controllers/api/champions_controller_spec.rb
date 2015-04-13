RSpec.describe Api::ChampionsController do
  describe 'GET :total_kills_and_deaths' do
    let(:count)  { 2 }
    let(:result) { JSON.parse(response.body) }

    before do
      count.times do
        create(:champion_match, kills: 3, deaths: 4)
      end

      get :total_kills_and_deaths
    end

    it 'returns the total amount of kills' do
      expect(result['kills']).to eq 6
    end

    it 'returns the total amount of deaths' do
      expect(result['deaths']).to eq 8
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
      expect(response.body).to eq '6'
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
      expect(response.body).to eq '6'
    end
  end

  describe 'GET :overall' do
    let(:champion) { create(:champion) }
    let(:result) do
      double(win_rate: 1, pick_rate: 2, total_victories: 3, total_losses: 4)
    end
    before do
      expect(ChampionMatchesStat).to receive(:overall_for_champion).
        with(champion).and_return(result)
    end

    it 'returns the overall stats for the champion' do
      get:overall, name: champion.name
      expect(response.body).to eq result.to_json
    end
  end
end
