Rails.application.routes.draw do
  post    'comments',     to: 'comments#create'
  post    'comments/:id', to: 'comments#update'
  delete  'comments/:id', to: 'comments#destroy'

  resources :comments

  get '/posts/my', to: 'posts#my'
  resources :posts

  # resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'posts#index'

  get 'persons/profile', as: 'user_root'

  devise_for :users
end
