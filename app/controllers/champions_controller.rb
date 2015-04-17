class ChampionsController < ApplicationController
  def index
    @champions = ChampionMatchesStat.all_champion_stats.
                 select('champion_id, name').group(:champion_id, :name)

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

    if params[:role].present?
      @champions = @champions.where('primary_role = ?', params[:role])
    end

    latest = Rails.cache.fetch("max_created_at_#{ENV['CACHE_COUNTER']}") do
      ChampionMatchesStat.select('max(created_at) as created_at').
       reorder('').first.created_at
    end
    my_params = "#{params[:role]}_#{params[:order]}_#{params[:asc]}"

    @champions = Rails.cache.fetch("stats_index_#{latest}_#{my_params}") do
      @champions.to_a
    end

    average_win_and_pick_rates

    if params[:rated].present?
      if params[:rated] == 'over'
        @champions.select! do |champion|
          champion.win_rate < @average_win_rate &&
            champion.pick_rate > @average_pick_rate
        end
      elsif params[:rated] == 'under'
        @champions.select! do |champion|
          champion.win_rate > @average_win_rate &&
            champion.pick_rate < @average_pick_rate
        end
      end
    end

    respond_to do |format|
      format.js { render '_all_champions', layout: false }
      format.html
    end
  end

  def show
    @champion = Rails.cache.fetch("stats_show_#{champion.name}") do
      ChampionMatchesStat.individual_champion_stats(champion)
    end

    @champions = Rails.cache.fetch('stats_show_all_champions') do
      ChampionMatchesStat.select(
        '(sum(victories)::float / sum(victories + losses)) * 100 as win_rate,
          sum(victories + losses)::float / (
            select sum(victories + losses) from champion_matches_stats
          ) * 1000 as pick_rate,
        champion_id'
      ).joins(:champion).group(:champion_id).to_a
    end

    average_win_and_pick_rates

  rescue NoMethodError
    @name = params[:name]
    render 'empty_search' and return # rubocop:disable Style/AndOr
  end

  def primary_role
    @roles = ChampionMatchesStat.all_champion_stats.select('primary_role').
             group(:primary_role).reorder('win_rate desc')
  end

  private

  def average_win_and_pick_rates
    win_rates = @champions.map(&:win_rate)
    @average_win_rate = win_rates.sum / win_rates.size
    pick_rates = @champions.map(&:pick_rate)
    @average_pick_rate = pick_rates.sum / pick_rates.size
  end

  def rounded_previous_hour
    # Time.zone.now = 2:08PM => 1:00PM
    Time.at ( ((Time.zone.now - 1.hour).to_f / 1.hour).floor * 1.hour)
  end
end
