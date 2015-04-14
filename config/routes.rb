Rails.application.routes.draw do
  root 'application#index'

  get '/about', to: 'application#about'

  namespace :champions do
    get '/', action: :index
    get '/search', action: :show
    get '/roles', action: :primary_role
  end

  get '/champions/:name', to: 'champions#show', as: :champion

  namespace :api do
    namespace :champions do
      get '/total_kills_and_deaths', action: :total_kills_and_deaths

      get '/:name/kills',  action: :kills
      get '/:name/deaths', action: :deaths

      get '/:name/overall', action: :overall
    end

    namespace :matches do
      get '/total', action: :total
    end
  end
end
