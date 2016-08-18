Rails.application.routes.draw do

 	root 'welcome#index'
 	
  resources :likes, only: [:create, :destroy]
  
  resources :statuses, only: [:new, :create, :edit, :update, :destroy]
  
  resources :users, only: [:new, :create, :edit, :update, :destroy]
  
  resources :sessions, only: [:new, :create, :destroy]

  resources :welcome, only: [:index]

 	delete '/signout', to: "sessions#destroy", as: "signout"

end
