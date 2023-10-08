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

  
  # namespace :api do 
  #   resources :tweets do
  #     resources :tweets
  #     member do
  #     end
  #   end
  # end

end



