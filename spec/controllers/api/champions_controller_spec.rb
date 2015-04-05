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
      expect(response.body).to eq '6'
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
      expect(response.body).to eq '6'
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

  describe 'GET :best_win_rate_with_history' do
    let(:time)       { (Time.zone.now - 59.minutes).to_i * 1000 }
    let(:other_time) { (Time.zone.now - 3.hours - 59.minutes).to_i * 1000 }

    let(:c1) { create(:champion) }
    let(:c2) { create(:champion) }
    let(:c3) { create(:champion) }
    let(:c4) { create(:champion) }
    let(:c5) { create(:champion) }

    let(:m1)  { create(:match, start_time: time) }
    let(:m2)  { create(:match, start_time: time) }
    let(:m3)  { create(:match, start_time: time) }
    let(:m4)  { create(:match, start_time: time) }
    let(:m5)  { create(:match, start_time: time) }
    let(:mm1) { create(:match, start_time: other_time) }
    let(:mm2) { create(:match, start_time: other_time) }
    let(:mm3) { create(:match, start_time: other_time) }
    let(:mm4) { create(:match, start_time: other_time) }
    let(:mm5) { create(:match, start_time: other_time) }

    before do
      Timecop.freeze(Time.utc(2015, 4, 5, 9, 7, 26))

      [m1, m2, m3, m4, m5].each do |m|
        create(:champion_match, champion: c1, match: m, victory: true)
      end

      [m1, m2, m3, m4].each do |m|
        create(:champion_match, champion: c2, match: m, victory: true)
      end
      create(:champion_match, champion: c2, match: m5, victory: false)

      [m1, m2, m3].each do |m|
        create(:champion_match, champion: c3, match: m, victory: true)
      end
      [m4, m5].each do |m|
        create(:champion_match, champion: c3, match: m, victory: false)
      end

      [m1, m2].each do |m|
        create(:champion_match, champion: c4, match: m, victory: true)
      end
      [m3, m4, m5].each do |m|
        create(:champion_match, champion: c4, match: m, victory: false)
      end

      create(:champion_match, champion: c5, match: m1, victory: true)
      [m2, m3, m4, m5].each do |m|
        create(:champion_match, champion: c5, match: m, victory: false)
      end

      # Matches with other time
      [mm1, mm2, mm3, mm4, mm5].each do |m|
        create(:champion_match, champion: c1, match: m, victory: true)
      end

      [mm1, mm2, mm3, mm4].each do |m|
        create(:champion_match, champion: c2, match: m, victory: true)
      end
      create(:champion_match, champion: c2, match: mm5, victory: false)

      [mm1, mm2, mm3].each do |m|
        create(:champion_match, champion: c3, match: m, victory: true)
      end
      [mm4, mm5].each do |m|
        create(:champion_match, champion: c3, match: m, victory: false)
      end

      [mm1, mm2].each do |m|
        create(:champion_match, champion: c4, match: m, victory: true)
      end
      [mm3, mm4, mm5].each do |m|
        create(:champion_match, champion: c4, match: m, victory: false)
      end

      create(:champion_match, champion: c5, match: mm1, victory: true)
      [mm2, mm3, mm4, mm5].each do |m|
        create(:champion_match, champion: c5, match: m, victory: false)
      end
    end

    let(:expected) do
      {
        c1.name =>
          {
            '1' => '100', '2' => '0', '3' => '0',
            '4' => '100', '5' => '0', '6' => '0'
          },
        c2.name =>
          {
            '1' => '80', '2' => '0', '3' => '0',
            '4' => '80', '5' => '0', '6' => '0'
          },
        c3.name =>
          {
            '1' => '60', '2' => '0', '3' => '0',
            '4' => '60', '5' => '0', '6' => '0'
          },
        c4.name =>
          {
            '1' => '40', '2' => '0', '3' => '0',
            '4' => '40', '5' => '0', '6' => '0'
          },
        c5.name =>
          {
            '1' => '20', '2' => '0', '3' => '0',
            '4' => '20', '5' => '0', '6' => '0'
          }
      }
    end

    after do
      Timecop.return
    end

    it 'returns the expected data' do
      get :best_win_rate_with_history
      expect(JSON.parse(response.body)).to eq expected
    end
  end
end
