Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :games, only: [:index, :create, :update, :show]
    end
  end

  resources :games, only: [:index, :show, :update]

  root to: "games#index"
end
