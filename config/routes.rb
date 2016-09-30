Rails.application.routes.draw do
  get '/posts/my', to: 'posts#my'
  resources :posts

  # resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'posts#index'

  get 'persons/profile', as: 'user_root'

  devise_for :users


end
