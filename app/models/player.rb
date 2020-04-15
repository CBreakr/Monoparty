class Player < ApplicationRecord
    has_many :player_games
    has_many :games, through: :player_games
    has_many :properties
    has_many :spaces, through: :properties
    has_many :games, through: :properties

    def get_player_game(game)
        player_games.find_by do |pg|
            pg.game == game
        end
    end

    def money_by_game(game)
        get_player_game(game).money
    end

    def has_conceded(game)
        get_player_game(game).has_conceded
    end
end
