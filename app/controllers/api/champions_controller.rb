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
      render json: ChampionMatchesStat.overall_for_champion(champion).to_json
    end

    private

    def champion
      @_champion ||= Champion.find_by_name(params[:name])
    end
  end
end
