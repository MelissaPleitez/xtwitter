Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root 'tweets#random'

  namespace :web do
    resources :tweets
    resources :tweets do
      member do
        post 'retweet', to: 'tweets#retweet'
        post 'quote', to: 'tweets#quote'
        post 'like', to: 'tweets#like'
        delete 'unlike', to: 'tweets#unlike'
        post 'reply', to: 'tweets#reply'
        get 'stats', to: 'tweets#stats'
      end
    end
  end

  namespace :web do
    resources :users, param: :username, only: [:show, :edit, :update]
    resources :users do
      member do
        post 'follow', to: 'users#follow'
        delete 'unfollow', to: 'users#unfollow'
      end
    end
  end

  
  namespace :api do 
    resources :tweets do
      resources :tweets
      member do
        post 'like', to: 'tweets#like'
        delete 'unlike', to: 'tweets#unlike'
        post 'retweet', to: 'tweets#retweet'
        post 'quote', to: 'tweets#quote'
        post 'reply', to: 'tweets#reply'
        post 'bookmark', to: 'tweets#bookmark'
      end
    end
  end

  namespace :api do 
    resources :users do
      resources :users
      member do
      end
    end
  end

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

end



