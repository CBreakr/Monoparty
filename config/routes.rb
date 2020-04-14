Rails.application.routes.draw do
  resources :cards
  resources :card_games
  resources :games
  resources :player_games
  resources :game_spaces
  resources :spaces
  resources :properties
  resources :players
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "games#index"
end
