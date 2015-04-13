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

  describe '.overall_for_champion' do
    let(:champion) { create(:champion) }
    let!(:stat1) do
      create(:champion_matches_stat,
             champion: champion,
             start_time: Time.parse('2015 Apr 01').to_i * 1000)
     end
    let!(:stat2) do
      create(:champion_matches_stat,
             champion: champion,
             start_time: Time.parse('2015 Apr 01').to_i * 1000)
     end
    let!(:statOther1) do
      create(:champion_matches_stat,
             start_time: Time.parse('2015 Apr 01').to_i * 1000)
    end
    let(:april_win_rate) do
      (stat1.victories + stat2.victories).to_f / (stat1.victories + stat1.losses + stat2.victories + stat2.losses) * 100
    end
    let(:april_pick_rate) do
      (stat1.victories + stat1.losses + stat2.victories + stat2.losses).to_f / april_total_picks * 100
    end
    let(:april_total_picks) do
      stat1.victories + stat1.losses + stat2.victories + stat2.losses + statOther1.victories + statOther1.losses
    end
    let!(:stat3) do
      create(:champion_matches_stat,
             champion: champion,
             start_time: Time.parse('2015 May 31').to_i * 1000)
     end
    let(:result) { ChampionMatchesStat.overall_for_champion(champion) }
    let(:may_win_rate) do
      stat3.victories.to_f / (stat3.victories + stat3.losses) * 100
    end
    let(:may_pick_rate) do
      (stat3.victories + stat3.losses).to_f / total_picks * 100
    end

    describe 'first month' do
      it 'calculates win rates for the first month' do
        expect(result.first.win_rate).to be_within(0.0005).of april_win_rate
      end

      it 'calculates pick rates for the first month' do
        byebug
        expect(result.first.pick_rate).to be_within(0.0005).of april_pick_rate
      end

      it 'extracts the month for the first month' do
        expect(result.first.month).to eq 4
      end

      it 'extracts the day' do
        expect(result.first.day).to eq 1
      end
    end

    describe 'second month' do
      it 'calculates win rates for the second month' do
        expect(result.second.win_rate).to be_within(0.0005).of may_win_rate
      end

      it 'calculates pick rates for the second month' do
        expect(result.second.pick_rate).to eq 100.0
      end

      it 'extracts the month for the second month' do
        expect(result.second.month).to eq 5
      end

      it 'extracts the day' do
        expect(result.second.day).to eq 31
      end
    end
  end
end
