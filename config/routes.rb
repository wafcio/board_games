Rails.application.routes.draw do
  resources :sessions, only: [:index]

  root to: 'welcome#index'
end
