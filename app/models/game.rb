class Game < ApplicationRecord
    has_many :game_spaces
    has_many :spaces, through: :game_spaces 
    has_many :player_games
    has_many :players, through: :player_games
    has_many :card_games 
    has_many :cards, through: :card_games 

    TURN_LIMIT = 10

    def is_active
        !(@is_started || @is_finished)
    end

    def get_sorted_spaces
        game_spaces.sort_by do |gs|
            gs.position
        end
    end

    def get_placement_spaces
        game_spaces.sort_by do |gs|
            gs.placement_order
        end
    end

    def setup(name)
        self.game_name = name

        # and then there are going to be other things to do?
        Game.transaction do
            # get the spaces
            GameSpace.create_default_setup(self)
            # GameCard.create_default_setup(self)
            save
        end
    end

    def start
        self.is_started = true
        self.turn_count = 1
        # set the player_order
        order = 1

        Game.transaction do
            player_games.shuffle.each do |pg|
                if order == 1 then
                    pg.is_current_turn = true
                end
                pg.turn_order = order
                pg.money = 1500
                pg.current_position = 1
                pg.save!
                order += 1
            end
            
            save!
        end
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
        #for now just moving the piece and nothing else
        total = first_roll + second_roll

        player_game = get_current_player_game

        next_position = player_game.current_position + total
        next_position %= (self.spaces.count)

        if next_position == 0 then
            next_position = self.spaces.count
        end        

        # for now give a random money amount
        player_game.update(current_position: next_position, money: (rand 1..10000))

        if rand > 0.90 then
            player_game.update(money: 0, has_conceded: true)
        end

        nil
    end

    def get_current_actions_list
        # based on the current state of everything, determine the actions for the player
    end

    def get_current_player_game
        self.player_games.find do |pg|
            pg.is_current_turn
        end
    end

    def sorted_player_games
        player_games.sort_by {|pg| pg.turn_order }
    end

    def get_next_player_game(current_turn)

        #have to deal with the fact that there might be players missing

        sorted_remaining = sorted_player_games.filter do |pg|
            !pg.has_conceded
        end

        next_player = nil
        found = false

        sorted_remaining.each do |pg|
            if pg.turn_order == current_turn then
                found = true
            elsif found then
                next_player = pg
                break
            end
        end

        if !next_player then
            #just take the first one
            next_player = sorted_remaining[0]
        end

        next_player
    end

    def end_the_turn
        player_game = get_current_player_game
        next_player_game = get_next_player_game(player_game.turn_order)
        player_game.is_current_turn = false
        next_player_game.is_current_turn = true

        if next_player_game.turn_order < player_game.turn_order then
            self.turn_count += 1
        end

        Game.transaction do
            player_game.save
            next_player_game.save
            save
        end

        check_end_condition
    end

    def check_end_condition
        if turn_count > TURN_LIMIT then
            #find player with the most money
            self.update(is_finished: true)
            winner = player_games.max_by {|pg| pg.money }
            winner.update(is_winner: true)
            return winner
        else
            #find if there's only one player remaining            
            remaining = player_games.filter {|pg| !pg.has_conceded }
            if remaining.count == 1 then
                self.update(is_finished: true)
                remaining[0].update(is_winner: true)
                return remaining[0]
            else
                nil
            end
        end
    end

    def winner
        if is_finished then
            return player_games.find {|pg| pg.is_winner }
        end

        nil
    end

    # oof, this one is weird
    def get_spaces_in_display_order

    end
end
