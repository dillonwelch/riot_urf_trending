module Api
  class ChampionController < ApplicationController
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
