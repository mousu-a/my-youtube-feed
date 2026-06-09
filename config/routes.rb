Rails.application.routes.draw do
  root 'welcome#index'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: 'sessions#auth_failure', as: 'auth_failure'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  get "up" => "rails/health#show", as: :rails_health_check
end
