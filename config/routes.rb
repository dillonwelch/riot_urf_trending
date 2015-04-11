Rails.application.routes.draw do
  root 'application#index'

  namespace :champions do
    get '/', action: :index
    get '/roles', action: :primary_role
    get '/by_win_rate', action: :by_win_rate
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
