module ApplicationHelper
  def riot_image_link(display_name)
    'http://ddragon.leagueoflegends.com/cdn/5.7.1/img/champion/'\
    "#{transform_display_name(display_name)}.png"
  end

  def riot_splash_link(display_name)
    'http://ddragon.leagueoflegends.com/cdn/img/champion/splash/'\
    "#{transform_display_name(display_name)}_0.jpg"
  end

  def riot_role_link(display_name)
    'http://ddragon.leagueoflegends.com/cdn/5.7.1/img/profileicon/'\
    "#{role_image_id(display_name)}.png"
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
    is_asc == 'true' ? 'caret-up' : 'caret-down'
  end

  def round_rate(rate, decimals=2)
    rate.round(decimals)
  end

  def normalize_average_rate(rate, average_rate)
    round_rate((((rate / average_rate) - 1) * 100))
  end

  def rate_class(rate)
    rate < 0 ? 'below-average' : 'above-average'
  end

  def rate_glyph_class(rate)
    rate < 0 ? 'arrow-down' : 'arrow-up'
  end

  def rate_tooltip(rate)
    base_key = 'champions.tooltips'
    rate < 0 ? I18n.t("#{base_key}.below_avg") : I18n.t("#{base_key}.above_avg")
  end

  def index_subtitle(options)
    if options[:role].present?
      options[:role].pluralize
    elsif options[:rated].present?
      I18n.t('champions.index.rated_champions_subtitle',
             rated: options[:rated]).capitalize
    else
      I18n.t('champions.index.subtitle')
    end
  end

  private

  def transform_display_name(raw_name)
    display_name = raw_name.gsub(/ /, '')

    begin
      { "Kog'Maw" => 'KogMaw',    "Kha'Zix"      => 'Khazix',
        "Rek'Sai" => 'RekSai',    "Cho'Gath"     => 'Chogath',
        "Vel'Koz" => 'Velkoz',    'Dr.Mundo'     => 'DrMundo',
        'LeBlanc' => 'Leblanc',   'Fiddlesticks' => 'FiddleSticks',
        'Wukong'  => 'MonkeyKing' }.fetch(display_name)
    rescue KeyError
      return display_name
    end
  end

  def role_image_id(role)
    { 'Assassin' => 657, 'Fighter'  => 658,
      'Mage'     => 659, 'Marksman' => 660,
      'Support'  => 661, 'Tank'     => 662 }.fetch(role)
  end
end
