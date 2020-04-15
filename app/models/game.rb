class Game < ApplicationRecord
    has_many :game_spaces
    has_many :spaces, through: :game_spaces 
    has_many :player_games
    has_many :players, through: :player_games
    has_many :card_games 
    has_many :cards, through: :card_games 

    TURN_LIMIT = 50

    def is_active
        !(@is_started || @is_finished)
    end

    def setup_game(name)
        @game_name = name
    end

    def set_cards(params)
        # get the selected cards, put them in random order (for ecah type)
        # the params should be a list of card_ids + quantities

        param.each do |card_quant|
            card_quant.quantity.times do |i|

            end
        end
    end

    def evaluate_roll(first_roll, second_roll)

    end

    def add_player(player_id)
        if !is_started then
            players << Player.find(player_id)
        end
    end

    def check_end_condition
        if turn_count >= TURN_LIMIT then
            #find player with the most money
            is_finished = true
            save
            return players.max_by {|p| p.money_by_game(self) }
        else
            #find if there's only one player remaining            
            remaining = players.filter {|p| !p.has_conceded(self) }
            if remaining.count == 1 then
                is_finished = true
                save
                return remaining[0]
            else
                nil
            end
        end
    end

    def get_current_actions_list

    end
end
