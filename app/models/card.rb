class Card < ApplicationRecord
    has_many :card_games
    has_many :games, through: :card_games

    # I think the game and player_game should be enough for any action
    def run_own_method(game, player_game)
        if self.respond_to?(method_name) then
            return send(method_name, game, player_game)
        end
        return nil
    end

    #
    # define any card methods we want
    #

    
    
    
    def go_back_three(player_game)
        player_game.current_position -= 3
        player_game.save 
        return true 
        #check logic 
    end 
    
    def advance_to_go(game, player_game)
        
        player_game.current_position = Space.get_go_position(game)
        player_game.money += 200
        player_game.save
        return nil
    end

    def advance_to_r_r(game, player_game)
        #need if you pass readingrailroad collect 200 logic 
        r_r_position = Space.find_by_name("Reading Railroad",game)
        if does_pass_go?("Reading Railroad",game,player_game)
            player_game.money += 200 
        end 

        player_game.current_position = r_r_position 
        player_game.save 
        return true 
    end 

    def advance_to_boardwalk(game, player_game)
        boardwalk_position = Space.find_by_name("Boardwalk",game)
        if does_pass_go?("Boardwalk",game,player_game)
            player_game.money += 200 
        end 

        player_game.current_position = boardwalk_position 
        player_game.save 
        return true 
        
    end 
    
    def advance_to_illinois_ave(game, player_game)
        #need if you pass go collect 200 logic 
        illinois_ave_position = Space.find_by_name("Illinois Avenue",game)
        if does_pass_go?("Illinois Avenue",game,player_game)
            player_game.money += 200 
        end 

        player_game.current_position = illinois_ave_position 
        player_game.save 
        return true 
        
    end 

    def advance_to_st_charles_place(game, player_game)
        #need if you pass go collect 200 logic 
        st_charles_place_position = Space.find_by_name("St. Charles Place",game)
        if does_pass_go?("St. Charles Place",game,player_game)
            player_game.money += 200 
        end 

        player_game.current_position = st_charles_place_position 
        player_game.save 
        return true 
        
    end 

    def nearest_utility(game, player_game)
        #if unowned, you may buy it from the Bank. 
        #If owned, throw dice and pay owner a total 10 times the amount thrown.
        w_w_position = Space.find_by_name("Water Works")
        e_c_position = Space.find_by_name("Electric Company")
        current_position = player_game.current_position

        if current_position < e_c_position
            current_position = e_c_position
        else 
            current_position = w_w_position
        end 
        return true 

        
    end 

    def nearest_railroad(game, player_game)
        #Advance token to the nearest Railroad and pay owner twice 
        #the rental to which he/she is otherwise entitled.
        #If Railroad is unowned, you may buy it from the Bank.
        rr_position = Space.find_by_name("Reading Railroad")
        pr_position = Space.find_by_name("Pennsylvania Railroad")
        bor_position = Space.find_by_name("B. & O. Railroad")
        slr_position = Space.find_by_name("Short Line R.R")
        current_position = player_game.current_position

        if current_position < rr_position && pr_position && bor_position && slr_position
            current_position = rr_position
        elsif current_position < pr_position && bor_position && slr_position
            current_position = pr_position
        elsif current_position < bor_position && slr_position
            current_position = bor_position
        else 
            current_position = slr_position
        end
        return true 
    end 

    def collect_twohun(player_game)
       player_game.money += 200
        player_game.save 
    end 

    def collect_onehun(player_game)
        player_game.money += 100
        player_game.save 
    end 

    def collect_onehunfifty(player_game)
        player_game.money += 150
        player_game.save 
    end 

    def collect_fifty(player_game)
        player_game.money += 50
        player_game.save 
    end 

    def collect_twenty_five(player_game)
        player_game.money += 50
        player_game.save 
    end 

    def collect_twenty(player_game)
        player_game.money += 50
        player_game.save 
    end 

    def collect_ten(player_game)
        player_game.money += 10
        player_game.save 
    end 

    def collect_fifty_from_all(player_game)
        all = player_game.game.players.count * 50
        player_game.money += all 
        player_game.save 
        #need logic to take what a losing player has left 
        PlayerGame.all.each do |pg|
            pg.take_money_away(50)
            pg.save 
        end 
        
    end 

    def collect_ten_from_all(player_game)
        all = player_game.game.players.count * 10
        player_game.money += all 
        player_game.save 
        #need logic to take what a losing player has left 
        PlayerGame.all.each do |pg|
            pg.take_money_away(10)
            pg.save 
        end 
    end 


    def pay_fifty_to_all(player_game)
        all = player_game.game.players.count * 50
        player_game.money -= all 
        player_game.save 
        #need logic to give 50 to each player 
        PlayerGame.all.each do |pg|
            pg.give_money_away(50)
            pg.save 
        end 
    end 
    
    def repairs(player_game)
        all = player_game.player.properties.count * 25
        player_game.money -= all 
        player_game.save 

    end 
    
    def pay_fourty(player_game)
        p_cost = player_game.player.properties.count * 40
        player_game.take_money_away(p_cost)
        player_game.save 
        
    end 

    
    def pay_fifty(player_game)
        player_game.take_money_away(50)
        player_game.save 
    end 

    def pay_fifteen(player_game)
        player_game.take_money_away(15)
        player_game.save 
    end 

    
    def get_out_of_jail(player_game)
        player_game.has_get_out_of_jail_card = true 
        player_game.save 
    end 

    def go_to_jail(game, player_game)
        #need help with logic 
        #set jail space set player position to it set rolls remaining = 3
        jail_position = Space.find_by_name("In Jail/Just Visiting",game)
        player_game.current_position = jail_position  
        player_game.in_jail_rolls_remaining = 3
        player_game.save 
        return nil 
    end 

    #bonus section 

    def super_good
        Space.create!(space_name: 'Super Good', space_cost: nil, rent_level1: nil,group: nil,space_type:"bonus", default_position: 41, method_name: "super_good")
        Space.create!(space_name: 'Super Good', space_cost: nil, rent_level1: nil,group: nil,space_type:"bonus", default_position: 42, method_name: "super_good")
        Space.create!(space_name: 'Super Good', space_cost: nil, rent_level1: nil,group: nil,space_type:"bonus", default_position: 43, method_name: "super_good")
        Space.create!(space_name: 'Super Good', space_cost: nil, rent_level1: nil,group: nil,space_type:"bonus", default_position: 44, method_name: "super_good")

    end 

    def super_bad
        Space.create!(space_name: 'Super Bad', space_cost: nil, rent_level1: nil,group: nil,space_type:"bonus", default_position: 41, method_name: "super_bad")
        Space.create!(space_name: 'Super Bad', space_cost: nil, rent_level1: nil,group: nil,space_type:"bonus", default_position: 42, method_name: "super_bad")
        Space.create!(space_name: 'Super Bad', space_cost: nil, rent_level1: nil,group: nil,space_type:"bonus", default_position: 43, method_name: "super_bad")
        Space.create!(space_name: 'Super Bad', space_cost: nil, rent_level1: nil,group: nil,space_type:"bonus", default_position: 44, method_name: "super_bad")

    end 


end
