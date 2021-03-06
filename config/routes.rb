TagCloud::Application.routes.draw do
  root to: 'user_sessions#index'

  match '/auth/:provider/callback', to: 'user_sessions#create'
  match '/auth/failure', to: 'user_sessions#error'
  match '/logout', to: 'user_sessions#logout'

  resources :tags, except: [:destroy]
  resources :mapped_values, except: [:index, :show]
  resources :user_sessions, only: [:index, :create]

  namespace :api do
    resources :mapped_values, only: [:create]
    resources :random_mapped_value, only: [:index]
  end
end
