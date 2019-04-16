Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :games, only: [:index]
      resources :players

      get '/login', to: 'auth#new'
      post '/login', to: 'auth#create'
      get '/logout', to: 'auth#destroy'


      namespace :game do
      get   '/active_games',    to: 'games#active'
      get   '/available_games', to: 'games#available'
      post  '/join',            to: 'games#join'
      post  '/turn_available',  to: 'games#turn?'
      get   '/importTurn',      to: 'games#import'
      put   '/exportTurn',      to: 'games#export'
      post  '/win',             to: 'games#win'
      delete '/exit',           to: 'games#exit'
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
