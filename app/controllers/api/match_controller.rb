module Api
  class MatchController < ApplicationController
    def total
      render json: Match.count
    end
  end
end
