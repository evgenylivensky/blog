Rails.application.routes.draw do
  post    'comments',     to: 'comments#create'
  post    'comments/:id', to: 'comments#update'
  delete  'comments/:id', to: 'comments#destroy'

  resources :comments

  get '/posts/my', to: 'posts#my'
  resources :posts

  root 'posts#index'

  devise_for :users

  get 'tags/:tag', to: 'posts#index'

  get 'static', to: 'statics#index'
end
