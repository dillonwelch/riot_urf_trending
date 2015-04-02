Rails.application.routes.draw do
  root 'application#index'

  get '/best_win_rate_with_history', to: 'application#best_win_rate_with_history'
end
