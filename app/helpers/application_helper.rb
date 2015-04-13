module ApplicationHelper
  def riot_image_link(display_name)
    'http://ddragon.leagueoflegends.com/cdn/5.7.1/img/champion/'\
    "#{transform_display_name(display_name)}.png"
  end

  def riot_splash_link(display_name)
    'http://ddragon.leagueoflegends.com/cdn/img/champion/splash/'\
    "#{transform_display_name(display_name)}_0.jpg"
  end

  def button_is_active?(value, order_param=params[:order])
    order = (order_param.nil? ? 'win_rate' : order_param)
    order == value.to_s
  end

  def button_active_class(is_active)
    is_active == true ? 'active' : ''
  end

  def button_glyph_class(is_active, is_asc=params[:asc])
    return '' unless is_active
    is_asc == 'true' ? 'glyphicon-chevron-up' : 'glyphicon-chevron-down'
  end

  private

  def transform_display_name(raw_name)
    display_name = raw_name.gsub(/ /, '')

    hash = {
      "Kog'Maw" => 'KogMaw',    "Kha'Zix"      => 'Khazix',
      "Rek'Sai" => 'RekSai',    "Cho'Gath"     => 'Chogath',
      "Vel'Koz" => 'Velkoz',    'Dr.Mundo'     => 'DrMundo',
      'LeBlanc' => 'Leblanc',   'Fiddlesticks' => 'FiddleSticks',
      'Wukong'  => 'MonkeyKing'
    }

    begin
      hash.fetch(display_name)
    rescue KeyError
      return display_name
    end
  end
end
