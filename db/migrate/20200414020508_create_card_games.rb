class CreateCardGames < ActiveRecord::Migration[6.0]
  def change
    create_table :card_games do |t|
      t.integer :card_id
      t.integer :game_id
      t.integer :deck_order
      t.boolean :is_used

      t.timestamps
    end
  end
end
