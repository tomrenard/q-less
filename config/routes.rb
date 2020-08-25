Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :events, only: [:index, :show, :update, :new, :create, :destroy] do
    resources :queue_estimations, only: [:new, :create]
  end

  resources :queue_estimations, only: [:index, :show, :destroy]

  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end
end
