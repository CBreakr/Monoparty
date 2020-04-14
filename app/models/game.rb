class Game < ApplicationRecord
    has_many :game_spaces
    has_many :spaces, through: :game_spaces 
    has_many :player_games
    has_many :players, through: :player_games
    has_many :card_games 
    has_many :cards, through: :card_games 
end
