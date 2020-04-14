class PlayerGame < ApplicationRecord
    belongs_to :player 
    belongs_to :game 
end
