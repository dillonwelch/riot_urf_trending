module Api
  class ChampionController < ApplicationController
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

    private

    def champion
      @champion ||= Champion.find_by_name(params[:name])
    end
  end
end
