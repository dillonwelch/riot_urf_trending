Rails.application.routes.draw do
  root 'application#home'

  namespace :champions do
    get '/by_win_rate', to: :by_win_rate
  end

  namespace :api do
    namespace :champions do
      get '/total_kills',  to: :total_kills
      get '/total_deaths', to: :total_deaths

      get '/:name/kills',  to: :kills
      get '/:name/deaths', to: :deaths

      get '/best_win_rate_with_history', to: :best_win_rate_with_history
    end

    namespace :matches do
      get '/total', to: :total
    end
  end
end
