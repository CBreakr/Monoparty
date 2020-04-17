class Property < ApplicationRecord
    belongs_to :player
    belongs_to :space 
    belongs_to :game

    def sale_detail
        "#{self.space.space_name} for $#{self.space.space_cost}"
    end

    def pay_rent(player_game)
        # for now just take the first level
        if player_game.player_id != self.player_id then
            rent_value = self.space.rent_level1
            if player_has_full_set(player_game) then
                rent_value *= 2
            end

            amount = player_game.take_money_away(rent_value)
            o = owner

            o.money += amount
            o.save

            if amount < rent_value then
                result.push({loser: "#{player_game.player.player_name} has lost"})
            end

            return {rent: "paid $#{rent_value} in rent to #{o.player.player_name} for #{self.space.space_name}"}
        end
        return nil
    end

    def owner
        PlayerGame.find_by(player_id: self.player_id, game_id: self.game_id)
    end

    # yay, we finally have a DELETE!
    def sell(player_game, prop)
        if prop.owner.player_id == player_game.player_id then
            Space.transaction do
                player_game.money += self.space.space_cost
                player_game.save
                prop.destroy
            end
        end
    end

    def player_has_full_set(player_game)
        Property.all.filter do |p|
            p.space.group == self.space.group
        end.all? do |p|
            p.player_id == player_game.player_id
        end
    end
end
