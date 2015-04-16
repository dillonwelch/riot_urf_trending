module Api
  class RolesController < ApplicationController
    def overall
      result = Rails.cache.fetch("api_roles_overall_#{params[:name]}") do
        ChampionMatchesStat.overall_for_role(params[:name]).to_json
      end
      render json: result
    end
  end
end
