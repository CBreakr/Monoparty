class Player < ApplicationRecord
    has_many :player_games
    has_many :games, through: :player_games
    has_many :properties
    has_many :spaces, through: :properties
    has_many :games, through: :properties
end
