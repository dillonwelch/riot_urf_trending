class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
  end

  def home
  end

  def best_win_rate_with_history
    hours = params[:hours].to_i
    # Time.zone.now = 2:08PM => 1:00PM
    time = Time.at ( ((Time.zone.now - 1.hour).to_f / 1.hour).floor * 1.hour)
    best = ChampionMatch.n_best(5, time)
    final_data = {}
    best.each do |champion|
      final_data[champion.name] = {}
      result = ChampionHistoryQuery.new(champion_id: champion.id, start_time: time).run
      result.each do |hour|
        final_data[champion.name][hour['time']] = hour['win_rate']
      end
    end
    render json: final_data.to_json
  end
end
