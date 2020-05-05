Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
 root 'tweets#index'
 

 devise_for :users, controllers: { registrations: 'users/registrations'  }

 resources :tweets do
    member do
      post :retweet
    end
    post 'like'
    post 'unlike'
  
  end

 resources :users do 
 end 

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
