class Card < ApplicationRecord
    has_many :card_games
    has_many :games, through: :card_games
end
