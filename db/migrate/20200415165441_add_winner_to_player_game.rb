class AddWinnerToPlayerGame < ActiveRecord::Migration[6.0]
  def change
    add_column :player_games, :is_winner, :boolean
  end
end
