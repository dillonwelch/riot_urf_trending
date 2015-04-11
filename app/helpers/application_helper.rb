module ApplicationHelper
  def riot_image_link(display_name)
    'http://ddragon.leagueoflegends.com/cdn/5.7.1/img/champion/'\
    "#{transform_display_name(display_name)}.png"
  end

  private

  def transform_display_name(display_name)
    display_name.gsub!(/ /, '')
    if display_name == "Kog'Maw"
      'KogMaw'
    elsif display_name == "Kha'Zix"
      'Khazix'
    elsif display_name == "Rek'Sai"
      'RekSai'
    elsif display_name == "Cho'Gath"
      'Chogath'
    elsif display_name == "Vel'Koz"
      'Velkoz'
    elsif display_name == 'Dr.Mundo'
      'DrMundo'
    elsif display_name == 'LeBlanc'
      'Leblanc'
    elsif display_name == 'Fiddlesticks'
      'FiddleSticks'
    elsif display_name == 'Wukong'
      'MonkeyKing'
    else
      display_name
    end
  end
end
