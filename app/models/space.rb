class Space < ApplicationRecord
    has_many :game_spaces
    has_many :games, through: :games_spaces
    has_many :properties
    has_many :players, through: :properties 
end
