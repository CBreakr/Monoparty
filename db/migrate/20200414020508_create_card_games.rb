class CreateCardGames < ActiveRecord::Migration[6.0]
  def change
    create_table :card_games do |t|
      t.int :card_id
      t.int :game_id
      t.int :deck_order
      t.boolean :is_used

      t.timestamps
    end
  end
end
