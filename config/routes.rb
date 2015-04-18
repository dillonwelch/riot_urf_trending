Rails.application.routes.draw do
  root 'application#index'

  get '/about', to: 'application#about'
  get '/urf', to: 'application#urf'

  namespace :champions do
    get '/', action: :index
    get '/search', action: :show
  end
  get '/champions/:name', to: 'champions#show', as: :champion

  namespace :roles do
    get '/', action: :index
  end
  get '/roles/:name', to: 'roles#show', as: :role

  namespace :api do
    namespace :champions do
      get '/total_kills_and_deaths', action: :total_kills_and_deaths

      get '/:name/kills',  action: :kills
      get '/:name/deaths', action: :deaths

      get '/:name/overall', action: :overall

      get '/names', action: :names
    end

    namespace :matches do
      get '/total', action: :total
    end

    namespace :roles do
      get '/:name/overall', action: :overall
    end
  end
end
