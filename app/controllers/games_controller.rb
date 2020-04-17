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

            result_hash = @game.evaluate_roll(first_roll, second_roll)

            after_actions(result_hash)

            # for now, for the purpose of testing
            # @game.end_the_turn
        end

        redirect_to game_path(@game)
    end

    def game_action
        if @game.is_active then
            result_hash = @game.run_action(params)

            after_actions(result_hash)
        end

        redirect_to game_path(@game)
    end

    def add_player
        if !game.is_started && !game.is_finished then
            @game.add_player(params[:player_id])
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

    def check_results_for_actions(result_hash)
        result_hash && result_hash.any? {|result| result.has_key?(:actions) }
    end

    def check_results_for_turn_end(result_hash)
        result_hash && result_hash.any? {|result| result.has_key?(:turn_end) }
    end

    def after_actions(result_hash)
        #if the turn is already over, just end it
        if !check_results_for_actions(result_hash) && !check_results_for_turn_end(result_hash) then
            sell_options = @game.set_sell_options
            if sell_options then
                if result_hash then
                    result_hash.push(sell_options)
                else
                    result_hash = [sell_options]
                end
            end
        end

        if result_hash != nil && result_hash.count > 0 && !check_results_for_turn_end(result_hash) then
            flash[:results] = result_hash 
        end
    end
end
