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

  describe '.find_by_game_id' do
    let!(:cm1) { create(:champion_match) }
    let!(:cm2) { create(:champion_match) }

    it 'only returns the ChampionMatch with the match game_id' do
      expect(ChampionMatch.find_by_game_id(cm1.match.game_id)).to eq [cm1]
    end

    describe 'game_id that does not exist' do
      let(:game_id) { cm1.match.game_id + cm2.match.game_id }

      it 'returns nil' do
        expect(ChampionMatch.find_by_game_id(game_id)).to eq []
      end
    end
  end

  describe '.find_by_riot_id' do
    let!(:cm1) { create(:champion_match) }
    let!(:cm2) { create(:champion_match) }

    it 'only returns the ChampionMatch with the champion riot_id' do
      expect(ChampionMatch.find_by_riot_id(cm1.champion.riot_id)).to eq [cm1]
    end

    describe 'riot_id that does not exist' do
      let(:riot_id) { cm1.champion.riot_id + cm2.champion.riot_id }

      it 'returns nil' do
        expect(ChampionMatch.find_by_riot_id(riot_id)).to eq []
      end
    end
  end

  describe '.n_best' do
    let(:result)   { ChampionMatch.n_best(5, Time.zone.now - 30.minutes) }

    describe 'victories and losses for one champion' do
      let(:champion) { create(:champion) }
      let(:match) do
        create(:match, start_time: (Time.zone.now - 1.hour).to_i * 1000)
      end
      let!(:cm1) do
        create(:champion_match, match: match, champion: champion, victory: true)
      end
      let!(:cm2) do
        create(:champion_match,
               match: match,
               champion: champion,
               victory: false)
      end

      describe 'victories and losses both in and out of bucket' do
        let!(:cm3) do
          create(:champion_match, champion: champion, victory: true)
        end
        let!(:cm4) do
          create(:champion_match, champion: champion, victory: false)
        end

        it 'only counts the victories in the time bucket' do
          expect(result.first.victories).to eq 1
        end

        it 'only counts the losses in the time bucket' do
          expect(result.first.losses).to eq 1
        end

        it 'has the right win rate' do
          expect(result.first.win_rate).to eq 0.5
        end
      end

      describe 'no victories in the time bucket' do
        let!(:cm3) do
          create(:champion_match, champion: champion, victory: false)
        end

        it 'coalesces victories to 0 ' do
          expect(result.first.victories).to eq 0
        end

        it 'only counts the losses in the time bucket' do
          expect(result.first.losses).to eq 1
        end

        it 'has the right win rate' do
          expect(result.first.win_rate).to eq 0
        end
      end

      describe 'no losses in the time bucket' do
        let!(:cm3) do
          create(:champion_match, champion: champion, victory: true)
        end

        it 'only counts the victories in the time bucket' do
          expect(result.first.victories).to eq 1
        end

        it 'coalesces losses to 0' do
          expect(result.first.losses).to eq 0
        end

        it 'has the right win rate' do
          expect(result.first.win_rate).to eq 1
        end
      end

      describe 'multiple victories and losses' do
        let!(:cm3) do
          create(:champion_match, champion: champion, victory: true)
        end
        let!(:cm4) do
          create(:champion_match, champion: champion, victory: true)
        end
        let!(:cm5) do
          create(:champion_match, champion: champion, victory: true)
        end
        let!(:cm6) do
          create(:champion_match, champion: champion, victory: false)
        end
        let!(:cm7) do
          create(:champion_match, champion: champion, victory: false)
        end

        it 'only counts the victories in the time bucket' do
          expect(result.first.victories).to eq 3
        end

        it 'coalesces losses to 0' do
          expect(result.first.losses).to eq 2
        end

        it 'has the right win rate' do
          expect(result.first.win_rate).to eq 0.6
        end
      end
    end
    describe 'multiple champions' do
      let(:winner)  { create(:champion) }
      let(:average) { create(:champion) }
      let(:loser)   { create(:champion) }

      before do
        5.times do
          create(:champion_match, champion: winner, victory: true)
        end

        2.times do
          create(:champion_match, champion: winner, victory: false)
        end

        3.times do
          create(:champion_match, champion: average, victory: true)
        end

        4.times do
          create(:champion_match, champion: average, victory: false)
        end

        1.times do
          create(:champion_match, champion: loser, victory: true)
        end

        6.times do
          create(:champion_match, champion: loser, victory: false)
        end
      end

      it 'calculates the win rates correctly' do
        expect(result.first.win_rate).to be_within(0.1).of 5 / 7.0
        expect(result.second.win_rate).to be_within(0.1).of 3 / 7.0
        expect(result.third.win_rate).to be_within(0.1).of 1 / 7.0
      end
    end
  end

  describe '.n_best_with_kda' do
    let(:result) do
      ChampionMatch.n_best_with_kda(5, Time.zone.now - 1.hour - 30.minutes)
    end

    describe 'victories and losses for one champion' do
      let(:champion) { create(:champion) }
      let(:match) do
        create(:match, start_time: (Time.zone.now - 1.hour).to_i * 1000)
      end
      let!(:cm1) do
        create(:champion_match, match: match, champion: champion, victory: true)
      end
      let!(:cm2) do
        create(:champion_match,
               match: match,
               champion: champion,
               victory: false)
      end

      it 'has the right kills' do
        expect(result.first.kills).to eq cm1.kills + cm2.kills
      end

      it 'has the right deaths' do
        expect(result.first.deaths).to eq cm1.deaths + cm2.deaths
      end

      it 'has the right assists' do
        expect(result.first.assists).to eq cm1.assists + cm2.assists
      end
    end

    describe 'multiple champions' do
      let(:winner)  { create(:champion) }
      let(:average) { create(:champion) }
      let(:loser)   { create(:champion) }
      let(:match) do
        create(:match, start_time: (Time.zone.now - 1.hour).to_i * 1000)
      end

      before do
        5.times do
          create(:champion_match,
                 champion: winner,
                 match: match,
                 kills: 1,
                 deaths: 2,
                 assists: 3)
        end

        3.times do
          create(:champion_match,
                 champion: average,
                 match: match,
                 kills: 2,
                 deaths: 0,
                 assists: 1)
        end

        1.times do
          create(:champion_match,
                 champion: loser,
                 match: match,
                 kills: 1,
                 deaths: 1,
                 assists: 1)
        end
      end

      it 'calculates the first champion kills correctly' do
        expect(result.first.kills).to eq 5
      end

      it 'calculates the first champion deaths correctly' do
        expect(result.first.deaths).to eq 10
      end

      it 'calculates the first champion assists correctly' do
        expect(result.first.assists).to eq 15
      end

      it 'calculates the second champion kills correctly' do
        expect(result.second.kills).to eq 6
      end

      it 'calculates the second champion deaths correctly' do
        expect(result.second.deaths).to eq 0
      end

      it 'calculates the second champion assists correctly' do
        expect(result.second.assists).to eq 3
      end

      it 'calculates the third champion kills correctly' do
        expect(result.third.kills).to eq 1
      end

      it 'calculates the third champion deaths correctly' do
        expect(result.third.deaths).to eq 1
      end

      it 'calculates the third champion assists correctly' do
        expect(result.third.assists).to eq 1
      end
    end
  end
end
