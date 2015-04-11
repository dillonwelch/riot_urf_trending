class ChampionsController < ApplicationController
  def index
    @champions = ChampionMatchesStat.select(
      '(sum(victories)::float / sum(victories + losses)) as win_rate,
      sum(victories + losses)::float / (
        select sum(victories + losses) from champion_matches_stats
      ) as pick_rate,
      champion_id, name'
    ).joins(:champion).group(:champion_id, :name).reorder('win_rate desc')
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
end
