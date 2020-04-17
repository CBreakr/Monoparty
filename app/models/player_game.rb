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

    def go_to_jail
        self.in_jail_rolls_remaining = 3
        self.save
        return [{message: "#{self.player.player_name} is in Jail", actions: end_turn_only_actions}]
    end

    def get_out_of_jail(cost)
        paid = take_money_away(cost)
        
        # self.game.end_the_turn(nil)
        if paid != cost then
            # this player has lost
            return [
                {loser: "#{self.player.player_name} has lost"},
                {actions: end_turn_only_actions}
            ]
        else
            self.in_jail_rolls_remaining = 0
            self.save
            return out_of_jail_options            
        end
    end

    def process_jail
        self.in_jail_rolls_remaining -= 1
        self.save
        if self.in_jail_rolls_remaining <= 0 then
            return get_out_of_jail(50)
        else
            actions = [
                {
                    text: "end the turn",
                    method_name: "end_the_turn",
                    params: {placeholder: ""}
                }
            ]

            if self.money >= 50 then
                actions.unshift({
                    text: "pay $50 fine", 
                    method_name:"pay_jail_fine", 
                    params: {placeholder: ""}                        
                })
            end

            if self.has_get_out_of_jail_card then
                actions.unshift({
                    text: "use get out of jail card", 
                    method_name:"use_jail_card", 
                    params: {placeholder: ""}   
                })
            end

            return [{actions: actions}]
        end
    end

    def use_jail_card
        self.has_get_out_of_jail_card = false
        self.in_jail_rolls_remaining = 0
        self.save
        out_of_jail_options
    end

    def pay_jail_fine
        return get_out_of_jail(50)
    end

    def out_of_jail_options
        return [
            {message: "Out of Jail!"},
            {actions: end_turn_only_actions}
        ]
    end

    def end_turn_only_actions
        return [
            {
                text: "end the turn",
                method_name: "end_the_turn",
                params: {placeholder: ""}
            }
        ]
    end
end
