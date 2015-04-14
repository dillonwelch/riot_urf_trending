RSpec.describe ApplicationHelper do
  describe '#riot_image_link' do
    def link(name)
      "http://ddragon.leagueoflegends.com/cdn/5.7.1/img/champion/#{name}.png"
    end

    describe 'special names' do
      { "Kog'Maw": 'KogMaw', "Kha'Zix": 'Khazix', "Cho'Gath": 'Chogath',
        "Vel'Koz": 'Velkoz', 'Dr.Mundo': 'DrMundo', 'LeBlanc': 'Leblanc',
        'Fiddlesticks': 'FiddleSticks',
        'Wukong': 'MonkeyKing' }.each do |key, value|
        describe "#{key}" do
          it "returns #{value}" do
            expect(riot_image_link(key.to_s)).to eq link value
          end
        end
      end
    end

    describe 'regular names' do
      %w(Sona Teemo Amumu).each do |name|
        describe "#{name}" do
          it "returns #{name}" do
            expect(riot_image_link(name)).to eq link name
          end
        end
      end
    end
  end

  describe '#riot_splash_link' do
    def link(name)
      "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/#{name}_0.jpg"
    end

    describe 'special names' do
      { "Kog'Maw": 'KogMaw', "Kha'Zix": 'Khazix', "Cho'Gath": 'Chogath',
        "Vel'Koz": 'Velkoz', 'Dr.Mundo': 'DrMundo', 'LeBlanc': 'Leblanc',
        'Fiddlesticks': 'FiddleSticks',
        'Wukong': 'MonkeyKing' }.each do |key, value|
        describe "#{key}" do
          it "returns #{value}" do
            expect(riot_splash_link(key.to_s)).to eq link value
          end
        end
      end
    end

    describe 'regular names' do
      %w(Sona Teemo Amumu).each do |name|
        describe "#{name}" do
          it "returns #{name}" do
            expect(riot_splash_link(name)).to eq link name
          end
        end
      end
    end
  end

  describe '#button_is_active?' do
    context 'order_param is nil' do
      context 'value matches default' do
        it 'returns true' do
          expect(button_is_active?('win_rate')).to be_truthy
        end
      end

      context 'value does not match default' do
        it 'returns false' do
          expect(button_is_active?('cats')).to be_falsey
        end
      end
    end
    context 'order param is not nil' do
      context 'value matches order_param' do
        it 'returns true' do
          expect(button_is_active?('pick_rate', 'pick_rate')).to be_truthy
        end
      end

      context 'value does not match order_param' do
        it 'returns false' do
          expect(button_is_active?('cats', 'pick_rate')).to be_falsey
        end
      end
    end
  end

  describe '#button_active_class' do
    context 'is active' do
      it 'returns the active class' do
        expect(button_active_class(true)).to eq 'active'
      end
    end

    context 'is not active' do
      it 'returns empty string' do
        expect(button_active_class(false)).to eq ''
      end
    end
  end

  describe '#button_glyph_class' do
    context 'is active' do
      context 'ascending' do
        it 'returns the up icon class' do
          expect(button_glyph_class(true, 'true')).to eq 'fa-caret-up'
        end
      end

      context 'descending' do
        it 'returns the down icon class' do
          expect(button_glyph_class(true, 'false')).to eq 'fa-caret-down'
        end
      end

      context 'no ascending param' do
        it 'returns the down icon class' do
          expect(button_glyph_class(true)).to eq 'fa-caret-down'
        end
      end
    end

    context 'is not active' do
      context 'ascending' do
        it 'returns empty string' do
          expect(button_glyph_class(false, 'true')).to eq ''
        end
      end

      context 'descending' do
        it 'returns empty string' do
          expect(button_glyph_class(false, 'false')).to eq ''
        end
      end

      context 'no ascending param' do
        it 'returns empty string' do
          expect(button_glyph_class(false)).to eq ''
        end
      end
    end
  end

  describe '#normalize_average_rate' do
    it 'normalizes the rate' do
      expect(normalize_average_rate(1.23, 4.56)).to eq -73.03
    end
  end

  describe '#round_rate' do
    it 'rounds by default to 2 places' do
      expect(round_rate(12.345678)).to eq 12.35
    end

    it 'accepts a decimal param' do
      expect(round_rate(12.345678, 4)).to eq 12.3457
    end
  end

  describe '#rate_class' do
    context 'rate below 0' do
      it 'returns below-average' do
        expect(rate_class(-0.234)).to eq 'below-average'
      end
    end

    context 'rate at 0' do
      it 'returns above-average' do
        expect(rate_class(0)).to eq 'above-average'
      end
    end

    context 'rate above 0' do
      it 'returns above-average' do
        expect(rate_class(0.345)).to eq 'above-average'
      end
    end
  end

  describe '#rate_glyph_class' do
    context 'rate below 0' do
      it 'returns fa-arrow-down' do
        expect(rate_glyph_class(-0.12)).to eq 'fa-arrow-down'
      end
    end

    context 'rate at 0' do
      it 'returns fa-arrow-up' do
        expect(rate_glyph_class(0)).to eq 'fa-arrow-up'
      end
    end

    context 'rate above 0' do
      it 'returns fa-arrow-up' do
        expect(rate_glyph_class(0.12)).to eq 'fa-arrow-up'
      end
    end
  end

  describe '#rate_tooltip ' do
    context 'rate below 0' do
      it 'returns below average' do
        expect(rate_tooltip(-0.12)).
          to eq I18n.t('champions.tooltips.below_avg')
      end
    end

    context 'rate at 0' do
      it 'returns above average' do
        expect(rate_tooltip(0)).
          to eq I18n.t('champions.tooltips.above_avg')
      end
    end

    context 'rate above 0' do
      it 'returns above average' do
        expect(rate_tooltip(0.12)).
          to eq I18n.t('champions.tooltips.above_avg')
      end
    end
  end
end
