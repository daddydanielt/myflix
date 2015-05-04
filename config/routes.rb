Myflix::Application.routes.draw do

  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'

  get 'home', to: 'videos#index'
  
  #get '/invite_friends', to: 'invite_friends#new'
  #get '/invite_friends', to: 'invite_friends#new'
  #resources 'invite_friends', only: [:new, :create]
  resources 'invitations', only: [:new, :create]

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  get '/register/:token', to: 'users#new_with_invitation_token', as: "register_with_invitation_token"
  
  resources :reset_passwords, only: [:show,:create]
  #get '/invalid_token', to: "reset_passwords#invalid_token"
  get '/invalid_token', to: "ui#invalid_token"


  resources :users, only: [:show]
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
  
  get '/home', to: 'videos#index'

  get '/forget_password', to: 'forget_passwords#new'
  get '/confirm_password_reset', to: 'forget_passwords#confirm_password_reset'
  resources 'forget_passwords', only: [:create]
  #--->
  #testing
  #get 'home', controller: 'home'
  #get 'home', to: 'home#home'
  #--->

  resources 'friendships'
  
  resources 'my_queues', only: [:index, :create, :destroy] do
    collection do
      post 'update_all', to: 'my_queues#update_all'
    end
  end

  resources 'videos', only: [:index, :show, :new, :create] do
    collection do
      post 'search', to: 'videos#search'
    end

    resources 'reviews', only: [:create]

    member do
      post 'comment', to: 'comments#create'
    end
  end

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end

  get '/people', to: 'relationships#following'

  resources 'relationships', only: [:create, :destroy] do
    #collection do
    #  get 'following', to: 'relationships#following'
    #end
  end

  #--------------------------------#
  mount StripeEvent::Engine, at: '/stripe_events' # provide a custom path
  #--------------------------------#

end
