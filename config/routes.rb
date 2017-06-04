Rails.application.routes.draw do
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/setting', to: 'static_pages#setting'
  get '/global', to: 'static_pages#global'
  get '/emos/index'
  delete '/emos/destroy/:id', to: 'emos#destroy',as: 'emos_destroy'
  post 'createEmo', to: 'emos#create', as: 'emoru'

  get '/users/all', to: 'users#index'
  get '/users/followings', to: 'users#index_following', as: 'following'
  get '/users/followers', to: 'users#index_follower', as: 'follower'
  delete '/users/destroy', to: 'users#destroy'
  get '/users/:nickname', to: 'users#show', as: 'users_show'


  get '/auth/twitter/callback', to: 'sessions#create', as: 'callback'
  get '/logout', to: 'sessions#destroy'
  get '/ajax/emo', to: 'emos#change_emo'
  get '/ajax/tab', to: 'emos#change_tab'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
