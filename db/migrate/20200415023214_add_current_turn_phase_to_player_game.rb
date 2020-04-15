class AddCurrentTurnPhaseToPlayerGame < ActiveRecord::Migration[6.0]
  def change
    add_column :player_games, :turn_phase, :string
  end
end
