module Api
  class ChampionsController < ApplicationController
    def total_kills_and_deaths
      total = ChampionMatch.select('sum(kills) as kills,
                                   sum(deaths) as deaths').reorder('').first

      render json: { kills: total.kills,
                     deaths: total.deaths }.to_json
    end

    def kills
      render json: ChampionMatch.where(champion_id: champion.id).sum(:kills)
    end

    def deaths
      render json: ChampionMatch.where(champion_id: champion.id).sum(:deaths)
    end

    def overall
      result = Rails.cache.fetch("api_champions_overall_#{champion.name}") do
        ChampionMatchesStat.overall_for_champion(champion).to_json
      end
      render json: result
    end

    def names
      render json: Champion.pluck(:name).to_json
    end
  end
end
