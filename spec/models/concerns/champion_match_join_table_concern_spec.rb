RSpec.describe ChampionMatchJoinTable do
  let(:champion)  { create(:champion) }
  let(:champion2) { create(:champion) }
  let(:match)     { create(:match) }
  let(:match2)    { create(:match) }

  let(:model) do
    create(:match_ban, champion: champion, match: match)
  end
  let(:model2) do
    create(:match_ban, champion: champion2, match: match2)
  end

  it { expect(model).to belong_to(:champion) }
  it { expect(model).to validate_presence_of(:champion) }
  it { expect(model).to belong_to(:match) }
  it { expect(model).to validate_presence_of(:match) }
  it { expect(model).to delegate_method(:game_id).to(:match) }
  it { expect(model).to delegate_method(:riot_id).to(:champion) }

  describe '.find_by_game_id' do
    it 'only returns the model with the match game_id' do
      result = MatchBan.find_by_game_id(model.match.game_id)
      expect(result).to eq [model]
    end

    describe 'game_id that does not exist' do
      let(:game_id) { model.match.game_id + model2.match.game_id }

      it 'returns nil' do
        expect(MatchBan.find_by_game_id(game_id)).to eq []
      end
    end
  end

  describe '.find_by_riot_id' do
    it 'only returns the model with the champion riot_id' do
      result = MatchBan.find_by_riot_id(model.champion.riot_id)
      expect(result).to eq [model]
    end

    describe 'riot_id that does not exist' do
      let(:riot_id) { model.champion.riot_id + model2.champion.riot_id }

      it 'returns nil' do
        expect(MatchBan.find_by_riot_id(riot_id)).to eq []
      end
    end
  end
end
