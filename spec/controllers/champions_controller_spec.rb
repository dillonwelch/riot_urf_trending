RSpec.describe ChampionsController do
  let(:_double) { ChampionMatchesStat.none }

  describe 'GET :index' do
    before do
      expect(ChampionMatchesStat).to receive(:all_champion_stats).
        and_return(_double)
      expect(controller).to receive(:average_rates)
      expect(controller).to receive(:filter_by_rated)
      expect(controller).to receive(:index_key)
    end

    it 'assigns champions' do
      get :index
      expect(assigns(:champions)).to eq _double
    end

    describe 'order params' do
      context 'none' do
        it 'orders by win_rate desc' do
          expect(_double).to receive(:reorder).with('win_rate desc')
          get :index
        end
      end

      context 'win_rate' do
        context 'asc' do
          it 'orders by win_rate asc' do
            expect(_double).to receive(:reorder).with('win_rate asc')
            get :index, order: 'win_rate', asc: 'true'
          end
        end

        context 'no asc' do
          it 'orders by win_rate desc' do
            expect(_double).to receive(:reorder).with('win_rate desc')
            get :index, order: 'win_rate'
          end
        end
      end

      context 'pick_rate' do
        context 'asc' do
          it 'orders by pick_rate asc' do
            expect(_double).to receive(:reorder).with('pick_rate asc')
            get :index, order: 'pick_rate', asc: 'true'
          end
        end

        context 'no asc' do
          it 'orders by pick_rate desc' do
            expect(_double).to receive(:reorder).with('pick_rate desc')
            get :index, order: 'pick_rate'
          end
        end
      end

      context 'name' do
        context 'asc' do
          it 'orders by name asc' do
            expect(_double).to receive(:reorder).with('name asc')
            get :index, order: 'name', asc: 'true'
          end
        end

        context 'no asc' do
          it 'orders by name desc' do
            expect(_double).to receive(:reorder).with('name desc')
            get :index, order: 'name'
          end
        end
      end

      context 'role' do
        it 'filters by primary role' do
          expect(_double).to receive(:where).with('primary_role = ?', 'rawr')
          get :index, role: 'rawr'
        end
      end
    end
  end

  describe 'GET :show' do
    let(:name) { 'rawr' }

    before do
      expect(controller).to receive(:champion).twice.
        and_return(double(name: name))
      expect(ChampionMatchesStat).to receive(:individual_champion_stats).
        and_return(_double)
      expect(ChampionMatchesStat).to receive(:select).and_return(_double)
      expect(controller).to receive(:average_rates)
      expect(_double).to receive(:joins).with(:champion).and_return(_double)
      expect(_double).to receive(:group).with(:champion_id).
        and_return(_double)
    end

    it 'assigns champion' do
      get :show, name: name
      expect(assigns(:champion)).to eq _double
    end

    it 'assigns champions' do
      get :show, name: name
      expect(assigns(:champions)).to eq _double
    end
  end
end
