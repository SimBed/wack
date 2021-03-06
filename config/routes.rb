Rails.application.routes.draw do

  get '/kitchen_utensils',  to: 'static_pages#new'
  #get 'rel_user_workouts/create'
  #get 'rel_user_workouts/destroy'
  root 'static_pages#home'
  get '/workouts/clear', to: 'workouts#clear', as: 'clear'
  get '/workouts/favourites', to: 'workouts#favourites', as: 'favourites'
  get '/workouts/search', to: 'workouts#search'
  get    '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  post '/show_from_welcome', to: 'schedulings#show_from_welcome'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :workouts
  resources :microposts,          only: [:create, :destroy]
  resources :rel_user_workouts,   only: [:create, :destroy]
  resources :attempts,          only: [:create, :destroy]
  resources :schedulings
end
