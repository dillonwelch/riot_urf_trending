RSpec.describe Api::MatchesController do
  describe 'GET :total' do
    let(:count) { 2 }

    before do
      count.times do
        create(:match)
      end
    end

    it 'returns the total amount of matches' do
      get :total
      expect(response.body).to eq count.to_json
    end
  end
end
