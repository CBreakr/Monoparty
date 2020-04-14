class Property < ApplicationRecord
    belongs_to :player
    belongs_to :space 
    belongs_to :game
end
