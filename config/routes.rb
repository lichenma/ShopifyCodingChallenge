Rails.application.routes.draw do
  root to: "images#index"
  devise_for :users
  #delete 'images/all', to: 'images#bulk_destroy'
  resources :images do 
    delete :bulk_destroy, on: :collection 
  end 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
