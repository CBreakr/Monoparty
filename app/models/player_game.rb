class PlayerGame < ApplicationRecord
    belongs_to :player 
    belongs_to :game 

    validate :player_and_game_valid_to_add, on: :create

    def player_and_game_valid_to_add
        if game && player && !game.is_started && !game.is_finished then

        else
            errors.add(:game_and_player, "not a valid addition")
        end
    end    
end
