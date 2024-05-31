Rails.application.routes.draw do
  require 'sidekiq/web'

  # Defines the root path route ("/")
  root "users#index"

  resources :users, only: [:index, :destroy]
  resources :daily_records, only: [:index]

  Rails.application.routes.draw do
    mount Sidekiq::Web => '/sidekiq' # Mount the Sidekiq web interface at /sidekiq
  end
 
end
