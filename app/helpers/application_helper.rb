module ApplicationHelper
  def riot_image_link(display_name)
    'http://ddragon.leagueoflegends.com/cdn/5.7.1/img/champion/'\
    "#{transform_display_name(display_name)}.png"
  end

  private

  def transform_display_name(display_name)
    display_name.gsub!(/ /, '')

    hash = {
      "Kog'Maw"      => 'KogMaw',
      "Kha'Zix"      => 'Khazix',
      "Rek'Sai"      => 'RekSai',
      "Cho'Gath"     => 'Chogath',
      "Vel'Koz"      => 'Velkoz',
      'Dr.Mundo'     => 'DrMundo',
      'LeBlanc'      => 'Leblanc',
      'Fiddlesticks' => 'FiddleSticks',
      'Wukong'       => 'MonkeyKing'
    }

    begin
      hash.fetch(display_name)
    rescue KeyError
      return display_name
    end
  end
end
