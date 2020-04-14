class CreatePlayerGames < ActiveRecord::Migration[6.0]
  def change
    create_table :player_games do |t|
      t.int :game_id
      t.int :player_id
      t.string :color
      t.int :turn_order
      t.boolean :is_current_turn
      t.int :money
      t.boolean :has_conceded
      t.int :in_jail_rolls_remaining
      t.boolean :has_get_out_of_jail_card
      t.int :current_position

      t.timestamps
    end
  end
end
