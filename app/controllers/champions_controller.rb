class ChampionsController < ApplicationController
  def index
    @champions = ChampionMatchesStat.select(
      '(sum(victories)::float / sum(victories + losses)) * 100 as win_rate,
      sum(victories + losses)::float / (
        select sum(victories + losses) from champion_matches_stats
      ) * 100 as pick_rate,
      champion_id, name'
    ).joins(:champion).group(:champion_id, :name).reorder('win_rate desc')
  end

  def search
    begin
      @champion = ChampionMatchesStat.select(
        '(sum(victories)::float / sum(victories + losses)) as win_rate,
        sum(victories + losses)::float / (
          select sum(victories + losses) from champion_matches_stats
        ) as pick_rate,
        champion_id, name'
      ).joins(:champion).where(champion_id: champion.id).
      group(:champion_id, :name).reorder('win_rate desc').first
    rescue NoMethodError
      @name = params[:name]
      render 'empty_search' and return
    end
  end

  def primary_role
    @roles = ChampionMatchesStat.select(
      '(sum(victories)::float / sum(victories + losses)) as win_rate,
      sum(victories + losses)::float / (
        select sum(victories + losses) from champion_matches_stats
      ) as pick_rate,
      primary_role'
    ).joins(:champion).group(:primary_role).reorder('win_rate desc')
  end

  def by_win_rate
  end

  private

  def champion
    @champion ||= Champion.find_by_lower_name(params[:name]).first
  end
end
