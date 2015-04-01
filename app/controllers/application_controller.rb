class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    @victories = ChampionMatch.joins(:champion).where(victory: true).select(:champion_id, :name).group(:champion_id, :name).select('count(victory) as victories')
    @losses = ChampionMatch.joins(:champion).where(victory: false).select(:champion_id, :name).group(:champion_id, :name).select('count(victory) as losses')
  end
end
