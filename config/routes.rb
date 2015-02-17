Myflix::Application.routes.draw do
  
  #root to: 'videos#index'
  root to: 'pages#front'

  #get '/front', to: 'users#front'
  get 'home', to: 'videos#index'
  
  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  
  resources 'my_queues', only: [:index, :create, :destroy]

  resources 'videos', only: [:index, :show, :new, :create] do
    collection do
      post 'search', to: 'videos#search'
    end

    resources 'reviews', only: [:create]

    member do 
      post 'comment', to: 'comments#create'
    end
  end


end
