Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :create] do
    member do
      get :followings
      get :followers
      #お気に入り機能
      get :likes
    end 
  end
  
  resources :microposts, only: [:create, :destroy] do
  
end

  resources :favorites, only: [:create, :destroy]

  resources :relationships, only: [:create, :destroy]
end
