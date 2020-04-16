class Space < ApplicationRecord
    has_many :game_spaces
    has_many :games, through: :games_spaces
    has_many :properties
    has_many :players, through: :properties 

    # I think the game and player_game should be enough for any action
    def run_own_method(game, player_game)
        if self.respond_to?(method_name) then
            return send(method_name, game, player_game)
        end
        return nil
    end

    def get_game_position(game)
        game_spaces.find_by do |gs|
            gs.game == game
        end.position
    end

    def is_property?
        return space_type == "residential" || space_type == "utility" || space_type == "railroad"
    end

    def is_card?
        return space_type == "chance" || space_type == "community_chest"
    end

    def self.get_go_position(game)
        go_space = game.game_spaces.find_by {|gs| gs.space.space_name == 'Go' }
        go_space.position 
    end 

    def self.find_by_name(name,game)
        byebug
        game.game_spaces.find {|gs| gs.space.space_name == name}
    end 

    def self.does_pass_go?(name,game,player_game)
        target_position = Space.find_by_name(name,game)
        go_position = Space.get_go_position(game)
        player_pos = player_game.current_position 
        
        if player_pos < target_position && go_position > player_pos && go_position < target_position
            return true 
        end 
        
        if player_pos > target_position && (go_position > player_pos || go_position < target_position) 
            return true 
        end 
        return false 
    end 

    def self.advance_to_space(name,game,player_game)
        target_position = Space.find_by_name(name,game)
        if does_pass_go?(name,game,player_game)
            player_game.money += 200 
        end 

        player_game.current_position = target_position 
        player_game.save 
        return true 
    end 

    def self.advance_to_card(game, player_game)
        # find ANY card space
        # set the player's position

        card_space = game.game_spaces.shuffle.find do |gs|
            gs.space.space_type == "community_chest" || gs.space.space_type == "chance"
        end

        player_game.current_position = card_space.position
    end

    
    def super_good(player_game)
        player_game.money += 1000
        player_game.save 
    end 

    def super_bad(player_game)
        player_game.take_money_away(1000)
        player_game.save 
    end 

    #
    # define any space methods we want
    #
end
