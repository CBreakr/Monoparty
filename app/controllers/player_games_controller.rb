class PlayerGamesController < ApplicationController
    def index 
        @player_games = PlayerGame.all 
    end
    
    def new 
        @player_game = PlayerGame.new
    end 

    def create 
        @player_game = PlayerGame.create(player_game_params)
        redirect_to games_path(@player_game)
    end 

    def show 
        @player_game = PlayerGame.find(params[:id])
    end 

    private 

    def player_game_params
        params.require(:player_game).permit(:game_id,:player_id)
    end 
end
