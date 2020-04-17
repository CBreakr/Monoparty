class Game < ApplicationRecord
    has_many :game_spaces
    has_many :spaces, through: :game_spaces 
    has_many :player_games
    has_many :players, through: :player_games
    has_many :card_games 
    has_many :cards, through: :card_games 
    has_many :properties

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
            CardGame.create_default_setup(self)
            # GameCard.create_default_setup(self)
            shuffle_cards("chance")
            shuffle_cards("community_chest")
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
                case order
                when 1
                    pg.color = "red"
                when 2
                    pg.color = "blue"
                when 3
                    pg.color = "green"
                when 4
                    pg.color = "yellow"
                end
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
                # CardGames.create
            end
        end
    end

    #
    #
    #
    def evaluate_roll(first_roll, second_roll)
        #for now just moving the piece and nothing else
        total = first_roll + second_roll

        player_game = get_current_player_game

        result = nil

        if player_game.in_jail_rolls_remaining > 0 then
            if first_roll == second_roll then
                result = player_game.get_out_of_jail(0)
            else
                result = player_game.process_jail
            end
        else
            result = move_player(total, player_game)
            # result = player_game.go_to_jail
        end

        if player_game.has_conceded then
            result.push({loser: "#{player_game.player.player_name} has lost"})
        end

        result.push({first_roll: first_roll})
        result.push({second_roll: second_roll})

        # byebug
        return result
    end

    #
    #
    #
    def move_player(total, current_player_game)
        next_position = current_player_game.current_position + total
        next_position %= (self.spaces.count)

        if next_position == 0 then
            next_position = self.spaces.count
        end

        if Space.does_pass_go_by_position?(next_position, self, current_player_game) then
            current_player_game.money += 200            
        end

        current_player_game.current_position = next_position
        current_player_game.save

        # targetted testing
        # Space.advance_to_space("Go To Jail", self, current_player_game)
        # Space.advance_to_space("Chance", self, current_player_game)
        
        result = evaluate_space(current_player_game)
        return result
    end

    #
    #
    #
    def evaluate_space(current_player_game)
        result = []

        gs = current_game_space(current_player_game.current_position)
        
        result.push({space: gs.space.space_name})

        if (gs.space.is_card? && gs.space.method_name)
            puts "EVALUATE CARD SPACE"

            # #no cards for now, just spaces
            # return result

            last_result = Card.run_from_space(self, gs, current_player_game)
            result.push(last_result)

            if (last_result && last_result[:card_result]) then
                #this mean we're supposed to re-evaluate again     

                next_gs = current_game_space(current_player_game.current_position)
                # make extra sure we're not on the same spot, to avoid a loop
                
                if gs.id != next_gs.id then
                    next_result = evaluate_space(current_player_game)
                    result.push(next_result) if next_result
                end
            end
        else 
            # OK, how do we do the buy/rent/etc options
            next_result = gs.space.process_space(self, current_player_game)
            # byebug
            result.push(next_result) if next_result
        end

        current_player_game.save

        result.flatten
    end

    #
    #
    #
    def current_game_space(position)
        game_spaces.find {|gs| gs.position == position }
    end

    #
    def set_sell_options
        pg = get_current_player_game
        if pg.player.properties.filter do |prop| 
            prop.game_id == self.id 
        end.count > 0 then
            return {actions: [
                    {
                        text: "sell property?", 
                        method_name:"choose_to_sell_property", 
                        params: {placeholder: ""}                        
                    },
                    {
                        text: "end the turn",
                        method_name: "end_the_turn",
                        params: {placeholder: ""}
                    }
                ]
            }
        else
            return {actions: [
                {
                    text: "end the turn",
                    method_name: "end_the_turn",
                    params: {placeholder: ""}
                }
            ]
        }
        end
    end

    #
    def run_action(params)
        method_name = params["method_name"]
        inner_params = params["inner"]

        #that should be all that I need
        if self.respond_to?(method_name) then
            return send(method_name, inner_params)
        end
    end

    #
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

    def buy_property(inner_params)
        # the inner_params should have the space_id
        space_id = inner_params["space_id"]
        return [Space.attempt_to_buy(space_id, get_current_player_game)]
    end

    def skip_to_sell(inner_params)
        # nothing to do here
        return nil
    end

    def choose_to_sell_property(inner_params)
        return [{sell: true}]
    end

    def pay_jail_fine(inner_params)
        pg = get_current_player_game
        return pg.pay_jail_fine
    end

    def use_jail_card(inner_params)
        pg = get_current_player_game
        return pg.use_jail_card
    end

    def end_the_turn(inner_params)

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
        return [{turn_end: "true"}]
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

    def shuffle_cards(card_type)
        CardGame.transaction do
            order = 1
            self.card_games.filter do |cg|
                cg.card.card_type == card_type
            end.shuffle.each do |cg|
                cg.deck_order = order
                cg.is_used = false
                order += 1
                cg.save!
            end
        end
    end

end
