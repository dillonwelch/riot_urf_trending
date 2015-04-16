class RolesController < ApplicationController
  def index
    latest = Rails.cache.fetch("max_created_at_#{ENV['CACHE_COUNTER']}") do
      ChampionMatchesStat.select('max(created_at) as created_at').
       reorder('').first.created_at
    end

    @roles = Rails.cache.fetch("stats_roles_index_#{latest}") do
      ChampionMatchesStat.all_champion_stats.select('primary_role').
        group(:primary_role).reorder('win_rate desc').to_a
    end
  end

  def show
    @role = Rails.cache.fetch("stats_roles_show_#{params[:name]}") do
      ChampionMatchesStat.individual_role_stats(params[:name])
    end
  end
end
