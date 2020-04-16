class PlayerGamesController < ApplicationController
    # def index 
    #     @player_games = PlayerGame.all 
    # end
    
    # def new 
    #     @player_game = PlayerGame.new
    # end 

    def create
        @player_game = PlayerGame.create(player_game_params)
        if !@player_game.valid? then
            # is there anything we need to do?
        end
        redirect_to game_path(@player_game.game)
    end

    # def show 
    #     @player_game = PlayerGame.find(params[:id])
    # end 

    private 

    def player_game_params
        params.require(:player_game).permit(:game_id, :player_id)
    end 
end
