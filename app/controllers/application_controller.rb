class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    # @merged = ChampionMatch.all_wins_and_losses
  end

  def best_win_rate_with_history
    hours = params[:hours].to_i
    best = ChampionMatch.n_best(5, Time.zone.now - 1.hour)
  end

  def last_n_hours_by_champion
    champion = params[:champion_name]

  end
end
