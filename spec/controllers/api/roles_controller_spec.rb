RSpec.describe Api::RolesController do
  describe 'GET :overall' do
    let(:role)   { 'Teemo Slayer' }
    let(:result) { double(win_rate: 1) }

    before do
      expect(ChampionMatchesStat).to receive(:overall_for_role).with(role).
        and_return(result)
    end

    it 'returns the overall stats for the role' do
      get :overall, name: role

      expect(response.body).to eq result.to_json
    end
  end
end
