module Api
  class MatchesController < ApplicationController
    def total
      render json: Match.count
    end
  end
end
