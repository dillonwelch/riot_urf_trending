module Api
  class ChampionsController < ApplicationController
    def total_kills
      render json: ChampionMatch.count(:kills)
    end

    def total_deaths
      render json: ChampionMatch.count(:deaths)
    end

    def kills
      render json: ChampionMatch.where(champion_id: champion.id).count(:kills)
    end

    def deaths
      render json: ChampionMatch.where(champion_id: champion.id).count(:deaths)
    end

    def best_win_rate_with_history
      hours = params[:hours].to_i
      # Time.zone.now = 2:08PM => 1:00PM
      time = Time.at ( ((Time.zone.now - 1.hour).to_f / 1.hour).floor * 1.hour)

      cache_key = "n_best_5_#{time}"
      best = Rails.cache.read(cache_key)

      if best.nil?
        best = ChampionMatch.n_best(5, time)
        Rails.cache.write(cache_key, best.to_a)
      end

      champions = Champion.where(id: best.map(&:champion_id)).pluck(:id, :name).to_h
      final_data = {}

      best.each do |champion|
        name = champions[champion.champion_id]
        final_data[name] = {}

        cache_key = "ChampionHistoryQuery_#{champion.champion_id}_#{time}"
        result = Rails.cache.read(cache_key)

        if result.nil?
          result = ChampionHistoryQuery.new(champion_id: champion.champion_id, start_time: time).run
          Rails.cache.write(cache_key, result.to_a)
        end

        result.each do |hour|
          final_data[name][hour['time']] = hour['win_rate']
        end
      end
      render json: final_data.to_json
    end

    private

    def champion
      @champion ||= Champion.find_by_name(params[:name])
    end
  end
end
