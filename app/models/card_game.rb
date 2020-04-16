class CardGame < ApplicationRecord
    belongs_to :card 
    belongs_to :game 

    def self.create_default_setup(game)
        Card.all.each do |c|
            c.default_quantity.times do
                CardGame.create(game:game, card: c)
            end
        end
    end
end
