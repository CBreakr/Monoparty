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
        end.placement_order
    end

    def is_property?
        return space_type == "residential" || space_type == "utility" || space_type == "railroad"
    end

    def is_card?
        return space_type == "chance" || space_type == "community_chest"
    end

    #
    # define any space methods we want
    #
end
