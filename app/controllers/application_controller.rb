class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    # @merged = ChampionMatch.all_wins_and_losses
  end

  def best_win_rate_with_history
    hours = params[:hours].to_i
    # best = ChampionMatch.n_best(5, Time.zone.now - 1.hour)
    best = ChampionMatch.n_best(5, Time.zone.now - 5.hours)
    final_data = {}
    best.each do |champion|
      final_data[champion.name] = {}
      _champion = Champion.find_by_name(champion.name)
      result = ChampionHistoryQuery.new(champion_id: _champion.id).run
      result.each do |hour|
        final_data[champion.name][hour['time']] = hour['win_rate']
      end
      # (1..6).each do |hour|
      #   data = ChampionMatch.n_best(5, hour.hours.ago).
      #     where('champions.name = ?', champion.name).first
      #   if data.present?
      #     final_data[champion.name][hour] = data.win_rate
      #   else
      #     final_data[champion.name][hour] = 0
      #   end
      # end
    end
    render json: final_data.to_json
  end

  # def last_n_hours_by_champion
  #   champion = params[:champion_name]
  # end
end
