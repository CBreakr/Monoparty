class CreateGameSpaces < ActiveRecord::Migration[6.0]
  def change
    create_table :game_spaces do |t|
      t.integer :space_id
      t.integer :game_id
      t.integer :placement_order
      t.integer :rent_level, default: 1

      t.timestamps
    end
  end
end
