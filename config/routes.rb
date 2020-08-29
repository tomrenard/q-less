Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :events, only: [:index, :show, :update, :new,:edit, :create, :destroy] do
    resources :queue_estimations, only: [:new, :create]
  end
  patch '/event_wishlist', to: "event_wishlists#update", as: :event_wishlist

  resources :queue_estimations, only: [:index, :show, :destroy]

  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end

  get '/tagged', to: "events#tagged", as: :tagged
  get '/dashboard', to: "pages#dashboard", as: :dashboard
end


