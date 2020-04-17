class PlayerGame < ApplicationRecord
    belongs_to :player 
    belongs_to :game 

    validate :player_and_game_valid_to_add, on: :create

    def player_and_game_valid_to_add
        if game && player && !game.is_started && !game.is_finished then

        else
            errors.add(:game_and_player, "not a valid addition")
        end
    end    

    def take_money_away(amount)
        amount_returned = amount
        if self.money < amount then
            amount_returned = self.money
            self.update(money: 0, has_conceded: true)
        else
            self.update(money: self.money - amount)
        end
        return amount_returned
    end

    def give_money_away(amount)
        amount_returned = amount
        
            self.update(money: self.money + amount)
    
        return amount_returned
    end

    def sell_property(sell_params)
        PlayerGame.transaction do
            total = 0
            sell_params[:sold_property_ids].each do |spid|
                if spid.present? then
                    p = Property.find(spid)
                    total += p.space.space_cost
                    p.destroy
                end
            end
            self.update(money: self.money + total)
            self.game.end_the_turn(nil)
        end
    end

    def sold_property_ids
        []
    end

    def properties
        Property.all.filter do |prop|
            prop.player_id == self.player_id && prop.game_id == self.game_id
        end
    end
end
