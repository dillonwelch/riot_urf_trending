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
end
