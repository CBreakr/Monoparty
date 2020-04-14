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

    def advance_to_go(game, player_game)
        player_game.current_position = 1
        player_game.money += 200
        player_game.save
        return nil
    end
end
