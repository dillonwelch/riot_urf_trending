class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def champion
    @_champion ||= Champion.find_by_lower_name(filtered_name).first
  end

  def filtered_name
    name = params[:name].downcase

    begin
      { 'kogmaw' => "Kog'Maw",    'khazix' => "Kha'Zix",
        'reksai' => "Rek'Sai",    'chogath' => "Cho'Gath",
        'velkoz' => "Vel'Koz",    'mundo' => 'Dr. Mundo',
        'dr mundo' => 'Dr. Mundo' }.fetch(name)
    rescue KeyError
      params[:name]
    end
  end
end
