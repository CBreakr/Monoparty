class Card < ApplicationRecord
    has_many :card_games
    has_many :games, through: :card_games

    def self.run_from_space(game, game_space, player_game)
        # byebug
        next_card = get_next_card(game, game_space.space.space_type)
        # byebug
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
        # byebug
        if self.respond_to?(method_name) then
            return send(method_name, game, player_game)
        end
        return nil
    end

    #
    # define any card methods we want
    #

    def advance_to_go(game, player_game)
        go_space = game.spaces.find_by {|sp| sp.name == 'Advance to "Go"' }
        player_game.current_position = go_space.get_game_position(game)
        player_game.money += 200
        player_game.save
        return nil
    end
end
