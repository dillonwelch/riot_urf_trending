Rails.application.routes.draw do
  root 'application#index'

  namespace :champions do
    get '/', action: :index
    get '/search', action: :search
    get '/roles', action: :primary_role

    get '/:name/last_day', action: :last_day
  end

  namespace :api do
    namespace :champions do
      get '/total_kills_and_deaths', action: :total_kills_and_deaths

      get '/:name/kills',  action: :kills
      get '/:name/deaths', action: :deaths

      get '/best_win_rate_with_history', action: :best_win_rate_with_history
    end

    namespace :matches do
      get '/total', action: :total
    end
  end
end
