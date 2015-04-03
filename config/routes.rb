Rails.application.routes.draw do
  root 'application#index'

  get '/home', to: 'application#home'

  get '/best_win_rate_with_history', to: 'application#best_win_rate_with_history'

  namespace :api do
    get '/champions/:name/kills', to: 'champion#kills'
    get '/champions/:name/deaths', to: 'champion#deaths'
  end
end
