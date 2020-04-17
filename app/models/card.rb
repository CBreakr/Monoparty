class Card < ApplicationRecord
    has_many :card_games
    has_many :games, through: :card_games

    def self.run_from_space(game, game_space, player_game)
        # byebug
        next_card = get_next_card(game, game_space.space.space_type)
        
        if next_card then
            #do a test for now
            result = nil
            Card.transaction do
                result = next_card.card.run_own_method(game, player_game)
                next_card.is_used = true
                next_card.save!
            end
            return {card: next_card.card.card_name, card_result: result}
        end
        nil
    end

    def self.get_next_card(game, card_type)
        if card_type == "community_chest" || card_type == "chance" then
            unused_cards = game.card_games.filter do |cg|
                cg.card.card_type == card_type && !cg.is_used
            end.sort_by do |cg|
                cg.deck_order
            end

            # byebug

            if unused_cards.count > 0 then
                return unused_cards[0]
            else
                game.shuffle_cards(card_type)
                return get_next_card(game, card_type)
            end
        end
        nil
    end

    # I think the game and player_game should be enough for any action
    def run_own_method(game, player_game)
        if self.respond_to?(method_name) then
            return self.send(method_name, game, player_game)
        end
        return nil
    end

    #
    # define any card methods we want
    #

    
    
    
    def go_back_three(game, player_game)
        if player_game.current_position == 1
            player_game.current_position = 38
        elsif player_game.current_position == 2 
            player_game.current_position = 39
        elsif player_game.current_position == 3 
            player_game.current_position = 40 
        else  
            player_game.current_position -= 3
        end 
        player_game.save 
        return true 
        #check logic 
    end 
    
    def advance_to_go(game, player_game)
        
        player_game.current_position = Space.get_go_position(game)
        player_game.save
        return true 
    end

    def advance_to_r_r(game, player_game)
        #need if you pass readingrailroad collect 200 logic 
        r_r_position = Space.find_by_name("Reading Railroad",game).position 
        if Space.does_pass_go?("Reading Railroad",game,player_game)
            player_game.money += 200 
        end 

        player_game.current_position = r_r_position 
        player_game.save 
        return true 
    end 

    def advance_to_boardwalk(game, player_game)
        #comparison of Integer with GameSpace failed
        boardwalk_position = Space.find_by_name("Boardwalk",game).position 
        if Space.does_pass_go?("Boardwalk",game,player_game)
            player_game.money += 200 
        end 

        player_game.current_position = boardwalk_position
        player_game.save 
        return true 
        
    end 
    
    def advance_to_illinois_ave(game, player_game)
        #need if you pass go collect 200 logic 
        illinois_ave_position = Space.find_by_name("Illinois Avenue",game).position 
        if Space.does_pass_go?("Illinois Avenue",game,player_game)
            player_game.money += 200 
        end 

        player_game.current_position = illinois_ave_position 
        player_game.save 
        return true 
        
    end 

    def advance_to_st_charles_place(game, player_game)
        #need if you pass go collect 200 logic 
        st_charles_place_position = Space.find_by_name("St. Charles Place",game).position  
        if Space.does_pass_go?("St. Charles Place",game,player_game)
            player_game.money += 200 
        end  

        player_game.current_position = st_charles_place_position 
        player_game.save 
        return true 
    end 

    def nearest_utility(game, player_game)
        #if unowned, you may buy it from the Bank. 
        #If owned, throw dice and pay owner a total 10 times the amount thrown.
        w_w_position = Space.find_by_name("Water Works",game).position
        e_c_position = Space.find_by_name("Electric Company",game).position
        current_position = player_game.current_position

        ww_distance = w_w_position - current_position
        ec_distance = e_c_position - current_position

        # if both are > 0 or both are < 0, take the smallest
        # if one is > 0, take that one

        target_position = nil

        if ww_distance * ec_distance > 0 then
            target_position = [w_w_position, e_c_position].min
        else
            target_position = [w_w_position, e_c_position].max
        end

        if Space.does_pass_go_by_position?(target_position, game, player_game) then
            player_game.money += 200
        end

        player_game.current_position = target_position
        player_game.save 
        return true 
    end 

    def nearest_railroad(game, player_game)
        #does this need to be gamespace?

        rr_position = Space.find_by_name("Reading Railroad", game).position
        pr_position = Space.find_by_name("Pennsylvania Railroad", game).position
        bor_position = Space.find_by_name("B. & O. Railroad", game).position
        slr_position = Space.find_by_name("Short Line R.R", game).position
        current_position = player_game.current_position

        # if all after current, take lowest
        # if all before current, take lowest

        # else take the lowest of those which is greater than current
        target_position = nil

        if rr_position < current_position && pr_position < current_position && bor_position < current_position && slr_position < current_position then
            target_position = [rr_position, pr_position, bor_position, slr_position].min 
        end

        if !target_position then
            target_position = 10000

            if rr_position > current_position && rr_position < target_position then
                target_position = rr_position
            end

            if pr_position > current_position && pr_position < target_position then
                target_position = pr_position
            end

            if bor_position > current_position && bor_position < target_position then
                target_position = bor_position
            end

            if slr_position > current_position && slr_position < target_position then
                target_position = slr_position
            end
        end

        if Space.does_pass_go_by_position?(target_position, game, player_game) then
            player_game.money += 200
        end
        
        player_game.current_position = target_position

        player_game.save 
        return true 
    end 

    def collect_twohun(game,player_game)
        player_game.money += 200
        player_game.save 
        return nil 
    end 

    def collect_onehun(game,player_game)
        player_game.money += 100
        player_game.save 
        return nil
    end 

    def collect_onehunfifty(game,player_game)
        player_game.money += 150
        player_game.save 
        return nil
    end 

    def collect_fifty(game,player_game)
        player_game.money += 50
        player_game.save 
        return nil
    end 

    def collect_twenty_five(game,player_game)
        player_game.money += 25
        player_game.save 
        return nil
    end 

    def collect_twenty(game,player_game)
        player_game.money += 20
        player_game.save 
        return nil 
    end 

    def collect_ten(game,player_game) 
        player_game.money += 10
        player_game.save 
        return nil
    end 

    def collect_fifty_from_all(game,player_game)
        #need logic to take what a losing player has left 
        total = 0
        PlayerGame.all.each do |pg|
            total + pg.take_money_away(50)
        end 
        
        player_game.money += total 
        player_game.save 
        
        return nil
    end 

    def collect_ten_from_all(game,player_game)
        total = 0
        PlayerGame.all.each do |pg|
            total + pg.take_money_away(10)
        end 
        
        player_game.money += total 
        player_game.save 
        
        return nil
    end 


    def pay_fifty_to_all(game,player_game)
        #need logic to give 50 to each player 
        PlayerGame.all.each do |pg|
            if pg.id != player_game.id
                amount = player_game.take_money_away(50)
                pg.money += amount 
                pg.save 
                if amount < 50 
                    break 
                end 
            end 
        end 
        return nil
    end 
    
    def repairs(game,player_game)
        all = player_game.player.properties.count * 25
        player_game.take_money_away(all)
        return nil

    end 
    
    def pay_fourty(game, player_game)
        p_cost = player_game.player.properties.count * 40
        player_game.take_money_away(p_cost)
        return nil
    end 

    
    def pay_fifty(game,player_game) 
        player_game.take_money_away(50)
        return nil
    end 

    def pay_fifteen(game, player_game)
        player_game.take_money_away(15)
        return nil
    end 

    
    def get_out_of_jail(game,player_game)
        player_game.has_get_out_of_jail_card = true 
        player_game.save 
        return nil
    end 

    def go_to_jail(game, player_game)
        #need help with logic 
        #set jail space set player position to it set rolls remaining = 3 
        jail_space = Space.find_by_name("In Jail/Just Visiting",game)
        player_game.current_position = jail_space.position  
        player_game.in_jail_rolls_remaining = 3
        player_game.save 
        return true 
    end 

    #bonus section 

    def super_good(game,player_game)
        Space.create!(space_name: 'Super Good', space_cost: nil, rent_level1: nil,group: nil,space_type:"bonus", default_position: 41, method_name: "super_good")
        Space.create!(space_name: 'Super Good', space_cost: nil, rent_level1: nil,group: nil,space_type:"bonus", default_position: 42, method_name: "super_good")
        Space.create!(space_name: 'Super Good', space_cost: nil, rent_level1: nil,group: nil,space_type:"bonus", default_position: 43, method_name: "super_good")
        Space.create!(space_name: 'Super Good', space_cost: nil, rent_level1: nil,group: nil,space_type:"bonus", default_position: 44, method_name: "super_good")
        return nil
    end 

    def super_bad(game,player_game)
        Space.create!(space_name: 'Super Bad', space_cost: nil, rent_level1: nil,group: nil,space_type:"bonus", default_position: 41, method_name: "super_bad")
        Space.create!(space_name: 'Super Bad', space_cost: nil, rent_level1: nil,group: nil,space_type:"bonus", default_position: 42, method_name: "super_bad")
        Space.create!(space_name: 'Super Bad', space_cost: nil, rent_level1: nil,group: nil,space_type:"bonus", default_position: 43, method_name: "super_bad")
        Space.create!(space_name: 'Super Bad', space_cost: nil, rent_level1: nil,group: nil,space_type:"bonus", default_position: 44, method_name: "super_bad")
        return nil
    end 


end
