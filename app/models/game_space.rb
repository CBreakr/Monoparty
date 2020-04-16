class GameSpace < ApplicationRecord
    belongs_to :space
    belongs_to :game

    def self.create_default_setup(game)
        Space.all.each do |space|
            placement = calculate_placement(space.default_position, Space.all.count)
            GameSpace.create!(game:game, space:space, position: space.default_position, placement_order: placement)
        end
    end

    def self.calculate_placement(pos, total)
        # total (must be divisible by 4!!!!)
        side_length = (1 + total/4)

        if (pos <= side_length)
            return (total - pos + 1)
        elsif (pos > total/2 && pos <= 3*total/4 + 1)
            return (pos - total/2)
        elsif (pos <= total/2)
            return (side_length + 2*(total/2 - pos) + 1)
        elsif (pos > 3*total/4 + 1)
            return (side_length + 2*(pos - 3*total/4 -1))
        end
    end
end
