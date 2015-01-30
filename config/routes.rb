Myflix::Application.routes.draw do
  
  root to: 'videos#index'

  get '/front', to: 'users#front'
  
  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  



  resources 'videos', only: [:show, :new, :create] do
    collection do
      post 'search', to: 'videos#search'
    end

    member do 
      post 'comment', to: 'comments#create'
    end
  end


end
