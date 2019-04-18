Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :games, only: [:index]
      resources :players

      get '/login', to: 'auth#new'
      post '/login', to: 'auth#create'
      get '/logout', to: 'auth#destroy'

      get 'player/available_players', to: 'players#available'
  
      get   'game/active_games',   to: 'games#active'
      post  'game/create',         to: 'games#create'
      post  'game/join',         to: 'games#join'
      post  'game/turn_available', to: 'games#turn?'
      post  'game/import_turn',    to: 'games#import'
      put   'game/export_turn',    to: 'games#export'
      post  'game/win',            to: 'games#win'
      delete 'game/exit',          to: 'games#exit'
      
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
