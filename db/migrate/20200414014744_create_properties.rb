class CreateProperties < ActiveRecord::Migration[6.0]
  def change
    create_table :properties do |t|
      t.integer :player_id
      t.integer :game_id
      t.integer :space_id

      t.timestamps
    end
  end
end
