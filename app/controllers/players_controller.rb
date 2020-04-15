class PlayersController < ApplicationController
    def index 
        @players = Player.all 
        @player = Player.new
    end 

    def create 
        @player = Player.create(player_params)
        redirect_to player_path(@player)
    end 

    def show 
        @player = Player.find(params[:id])
    end 

    private 

    def player_params
        params.require(:player).permit(:player_name)
    end 
end
