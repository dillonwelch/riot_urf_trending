class RolesController < ApplicationController
  def index
    @roles = ChampionMatchesStat.all_champion_stats.select('primary_role').
             group(:primary_role).reorder('win_rate desc')
  end

  def show
    @role = ChampionMatchesStat.individual_role_stats(params[:name])
  end
end
