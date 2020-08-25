Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :events, only: [:index, :show, :new, :create, :destroy] do
    resources :queue_estimations, only: [:new, :create]
  end

  resources :queue_estimations, only: [:index, :show, :destroy]
end
