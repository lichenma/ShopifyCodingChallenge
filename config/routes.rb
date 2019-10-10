Rails.application.routes.draw do
  root to: "images#index"
  devise_for :users
  resources :images
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
end
