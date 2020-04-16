class GamesController < ApplicationController
    before_action :get_game, except: [:index, :create]

    def index
        @games = Game.all
        @game = Game.new
    end

    def show
        if @game.is_finished then
            render :finished_game        
        elsif @game.is_started then
            render :active_game
        else
            @players_not_in_game = Player.all.filter do |p|
                !@game.players.include?(p)
            end
            @player_game = PlayerGame.new
            @player_game.game = @game
            render :game_setup
        end
    end

    def create
        # game = Game.new.setup_game(game_params[:game_name])
        game = Game.new
        game.setup(game_params[:game_name])
        redirect_to game_path(game)
    end

    def update
        # this will be for updating the cards
        if @game.is_active then
            @game.game_name = game_params[:game_name]
            @game.set_cards(game_params)
            @game.save
        end 

        redirect_to game_path(@game)
    end

    def start
        # does this not work automatically?
        @game.start
        redirect_to game_path(@game)
    end

    def roll
        if @game.is_active then
            first_roll = rand 1..6
            second_roll = rand 1..6

            session[:first_roll] = first_roll
            session[:second_roll] = second_roll

            @game.evaluate_roll(first_roll, second_roll)
            @game.save

            # for now, for the purpose of testing
            @game.end_the_turn
        end

        redirect_to game_path(@game)
    end

    def game_action
        if @game.is_active then
            @game.run_action(params[:action_name])
        end
        redirect_to game_path(@game)
    end

    def add_player
        if !game.is_started && !game.is_finished then
            @game.add_player(params[:player_id])
        end
        redirect_to game_path(@game)
    end

    def end_turn
        if @game.is_active then
            @game.end_the_turn
        end
        redirect_to game_path(@game)
    end

    private

    def game_params
        params.require(:game).permit(:game_name)
    end

    def get_game
        @game = Game.find(params[:id])
    end
end
