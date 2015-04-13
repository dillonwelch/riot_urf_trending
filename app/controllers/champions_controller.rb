class ChampionsController < ApplicationController
  def index
    @champions = ChampionMatchesStat.select(
      '(sum(victories)::float / sum(victories + losses)) * 100 as win_rate,
      sum(victories + losses)::float / (
        select sum(victories + losses) from champion_matches_stats
      ) * 100 as pick_rate,
      champion_id, name'
    ).joins(:champion).group(:champion_id, :name)

    if params[:order] == 'win_rate' || params[:order].nil?
      if params[:asc] == 'true'
        @champions = @champions.reorder('win_rate asc')
      else
        @champions = @champions.reorder('win_rate desc')
      end
    elsif params[:order] == 'pick_rate'
      if params[:asc] == 'true'
        @champions = @champions.reorder('pick_rate asc')
      else
        @champions = @champions.reorder('pick_rate desc')
      end
    elsif params[:order] == 'name'
      if params[:asc] == 'true'
        @champions = @champions.reorder('name asc')
      else
        @champions = @champions.reorder('name desc')
      end
    end

    win_rates = @champions.map(&:win_rate)
    @average_win_rate = win_rates.sum / win_rates.size
    @average_pick_rate = 100.0 / @champions.size

    respond_to do |format|
      format.js { render '_all_champions', layout: false }
      format.html
    end
  end

  def search
    begin
      @champion = ChampionMatchesStat.select(
        '(sum(victories)::float / sum(victories + losses)) * 100 as win_rate,
        sum(victories + losses)::float / (
          select sum(victories + losses) from champion_matches_stats
        ) * 100 as pick_rate,
        champion_id, name'
      ).joins(:champion).where(champion_id: champion.id).
      group(:champion_id, :name).reorder('').first

      @champions = ChampionMatchesStat.select(
        '(sum(victories)::float / sum(victories + losses)) * 100 as win_rate,
        champion_id'
      ).joins(:champion).group(:champion_id)

      win_rates = @champions.map(&:win_rate)
      @average_win_rate = win_rates.sum / win_rates.size
      @average_pick_rate = 100.0 / @champions.size

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

  private

  def rounded_previous_hour
    # Time.zone.now = 2:08PM => 1:00PM
    Time.at ( ((Time.zone.now - 1.hour).to_f / 1.hour).floor * 1.hour)
  end

  def champion
    @_champion ||= Champion.find_by_lower_name(params[:name]).first
  end
end
