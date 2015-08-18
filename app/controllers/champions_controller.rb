class ChampionsController < ApplicationController
  def index
    @champions = ChampionMatchesStat.all_champion_stats.
                 select('champion_id, name').group(:champion_id, :name)

    filter_by_params

    @champions = Rails.cache.fetch(index_key) do
      @champions.to_a
    end

    average_rates
    filter_by_rated

    respond_to do |format|
      format.js { render '_all_champions', layout: false }
      format.html
    end
  end

  def show
    @champion = Rails.cache.fetch("stats_show_#{champion.name}") do
      ChampionMatchesStat.individual_champion_stats(champion)
    end

    @champions = stats_show_all_champions

    average_rates

  rescue NoMethodError
    @name = params[:name]
    render 'empty_search' and return # rubocop:disable Style/AndOr
  end

  def primary_role
    @roles = ChampionMatchesStat.all_champion_stats.select('primary_role').
             group(:primary_role).reorder('win_rate desc')
  end

  private

  def bans
    Rails.cache.fetch('stats_total_bans') do
      MatchBan.select(
        'count(champion_id) as total_bans,
         champion_id,
         count(match_bans.champion_id)::float / (
           select count(match_bans.id) from match_bans
         ) * 100 as ban_rate').
        group(:champion_id).order(:champion_id)
    end
  end

  def average_rates
    win_rates = @champions.map(&:win_rate)
    @average_win_rate = win_rates.sum / win_rates.size
    pick_rates = @champions.map(&:pick_rate)
    @average_pick_rate = pick_rates.sum / pick_rates.size
    @bans = bans
  end

  def rounded_previous_hour
    # Time.zone.now = 2:08PM => 1:00PM
    Time.at ( ((Time.zone.now - 1.hour).to_f / 1.hour).floor * 1.hour)
  end

  def filter_by_params
    case params[:order]
    when 'win_rate'
      filter_asc('win_rate')
    when 'pick_rate'
      filter_asc('pick_rate')
    when 'name'
      filter_asc('name')
    else
      filter_asc('win_rate')
    end

    return unless params[:role].present?

    @champions = @champions.where('primary_role = ?', params[:role])
  end

  def filter_asc(order)
    if params[:asc] == 'true'
      @champions = @champions.reorder("#{order} asc")
    else
      @champions = @champions.reorder("#{order} desc")
    end
  end

  def cache_key
    "#{params[:role]}_#{params[:order]}_#{params[:asc]}"
  end

  def index_key
    "stats_index_#{max_created_at}_#{cache_key}"
  end

  def max_created_at
    @_max = Rails.cache.fetch("max_created_at_#{ENV['CACHE_COUNTER']}") do
      #ChampionMatchesStat.select('max(created_at) as created_at').
      #reorder('').first.created_at
      ENV['MAX_CREATED_AT']
    end
  end

  def overrated?(champion)
    champion.win_rate < @average_win_rate &&
      champion.pick_rate > @average_pick_rate
  end

  def underrated?(champion)
    champion.win_rate > @average_win_rate &&
      champion.pick_rate < @average_pick_rate
  end

  def filter_by_rated
    return unless params[:rated].present?

    if params[:rated] == 'over'
      @champions.select! do |champion|
        overrated?(champion)
      end
    elsif params[:rated] == 'under'
      @champions.select! do |champion|
        underrated?(champion)
      end
    end
  end

  def stats_show_all_champions
    Rails.cache.fetch('stats_show_all_champions') do
      ChampionMatchesStat.select(
        '(sum(victories)::float / sum(victories + losses)) * 100 as win_rate,
          sum(victories + losses)::float / (
            select sum(victories + losses) from champion_matches_stats
          ) * 1000 as pick_rate,
        champion_id'
      ).joins(:champion).group(:champion_id).to_a
    end
  end
end
