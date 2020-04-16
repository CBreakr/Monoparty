class PlayerGame < ApplicationRecord
    belongs_to :player 
    belongs_to :game 

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
        end
        return amount_returned
    end
end
