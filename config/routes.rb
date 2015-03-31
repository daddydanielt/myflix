Myflix::Application.routes.draw do
  
  #root to: 'videos#index'
  root to: 'pages#front'

  #get '/front', to: 'users#front'
  get 'home', to: 'videos#index'
  
  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  #get '/user_profile/:id', to: 'users#show'
  resources 'users', only: [:show]
  
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  
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


  get '/people', to: 'relationships#following'

  resources 'relationships', only: [:create, :destroy] do
    #collection do
    #  get 'following', to: 'relationships#following'
    #end
  end

end
