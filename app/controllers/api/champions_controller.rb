module Api
  class ChampionsController < ApplicationController
    def total_kills
      render json: ChampionMatch.sum(:kills)
    end

    def total_deaths
      render json: ChampionMatch.sum(:deaths)
    end

    def kills
      render json: ChampionMatch.where(champion_id: champion.id).sum(:kills)
    end

    def deaths
      render json: ChampionMatch.where(champion_id: champion.id).sum(:deaths)
    end

    def best_win_rate_with_history
      time = rounded_previous_hour

      best = Rails.cache.fetch("n_best_5_#{time}") do
        ChampionMatch.n_best(5, time).to_a
      end

      ids = best.map(&:champion_id)
      champions = Champion.where(id: ids).pluck(:id, :name).to_h

      render json: history_data(best, time, champions)
    end

    private

    def champion
      @champion ||= Champion.find_by_name(params[:name])
    end

    def rounded_previous_hour
      # Time.zone.now = 2:08PM => 1:00PM
      Time.at ( ((Time.zone.now - 1.hour).to_f / 1.hour).floor * 1.hour)
    end

    def champion_history(champion, time)
      cache_key = "ChampionHistoryQuery_#{champion.champion_id}_#{time}"
      Rails.cache.fetch(cache_key) do
        ChampionHistoryQuery.new(champion_id: champion.champion_id,
                                 start_time: time).run.to_a
      end
    end

    def history_data(best, time, champions)
      final_data = {}

      best.each do |champion|
        name = champions[champion.champion_id]
        final_data[name] = {}

        champion_history(champion, time).each do |hour|
          final_data[name][hour['time']] = hour['win_rate']
        end
      end

      final_data.to_json
    end
  end
end
