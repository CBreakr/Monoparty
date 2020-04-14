class CreatePlayerGames < ActiveRecord::Migration[6.0]
  def change
    create_table :player_games do |t|
      t.integer :game_id
      t.integer :player_id
      t.string :color
      t.integer :turn_order
      t.boolean :is_current_turn
      t.integer :money
      t.boolean :has_conceded
      t.integer :in_jail_rolls_remaining, default: 0
      t.boolean :has_get_out_of_jail_card
      t.integer :current_position

      t.timestamps
    end
  end
end
