Rails.application.routes.draw do
  get 'user/index'

#   , controllers: {
#   sessions: 'users/sessions',       # Controlador personalizado para sesiones
#   registrations: 'users/registrations' # Controlador personalizado para registros
# }
  # root "users#index"
 devise_for :users,  controllers: {
    registrations: 'users/registrations' # Controlador personalizado para registros
  }

  namespace :api do

    resources :registration do
      member do
       post 'sing_in', to: 'registration#create'
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
      resources :tweets
      member do
        # get 'new', to: 'tweets#new'
        # get 'show', to: 'tweets#show'
        # get 'index', to: 'tweets#index'
        # post 'create', to: 'tweets#create'
        # get 'edit', to: 'tweets#edit'
        # patch 'update', to: 'tweets#update'
        # post 'like', to: 'tweets#like'
        # delete 'unlike', to: 'tweets#unlike'
        # post 'retweet', to: 'tweets#retweet'
        # post 'quote', to: 'tweets#quote'
        # get 'reply', to: 'tweets#reply'
        # post 'bookmark', to: 'tweets#bookmark'
        # get 'stats', to: 'tweets#stats'
      end
    end
  end
  
  namespace :web do 
    resources :tweets
    resources :tweets do
      member do 
        post 'retweet', to: 'tweets#retweet'
      end
    end
  end
 
  # namespace :web do
  #   resources :tweets do
  #     member do 
  #       post 'retweet', to: 'tweets#retweet'
  #     end
  #   end
  # end

end


