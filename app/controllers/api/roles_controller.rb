module Api
  class RolesController < ApplicationController
    def overall
      render json: ChampionMatchesStat.overall_for_role(params[:name]).to_json
    end
  end
end
