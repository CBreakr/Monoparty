class GameSpace < ApplicationRecord
    belongs_to :space
    belongs_to :game

    def self.create_default_setup(game)
        Space.all.each do |space|
            GameSpace.create!(game:game, space:space, placement_order: space.default_position)
        end
    end
end
