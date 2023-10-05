Rails.application.routes.draw do
  get 'user/index'
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "users#index"
 devise_for :users
  namespace :api do
    resources :authentication do
      member do
       post 'log_in', to: 'auth#create'
      end 
    end  
    resources :registration do
      member do
       post 'create', to: 'registration#create'
      end 
    end 
    resources :sessions do
      member do
       post 'login', to: 'sessions#create'
       delete 'logout', to: 'sessions#destroy'
      end 
    end 
  end


  namespace :api do 
    resources :tweets do
      member do
        get 'new', to: 'tweets#new'
        post 'create', to: 'tweets#create'
        get 'edit', to: 'tweets#edit'
        patch 'update', to: 'tweets#update'
        post 'like', to: 'tweets#like'
        delete 'unlike', to: 'tweets#unlike'
        post 'retweet', to: 'tweets#retweet'
        post 'quote', to: 'tweets#quote'
        get 'reply', to: 'tweets#reply'
        post 'bookmark', to: 'tweets#bookmark'
        get 'stats', to: 'tweets#stats'
      end
    end
  end
  
  namespace :web do 
    resources :tweets do 
      member do 
        get 'new', to: 'tweets#new'
        post 'create', to: 'tweets#create'
        get 'edit', to: 'tweets#edit'
        patch 'update', to: 'tweets#update'
      end
    end
  end
 

end


