class CreateGameSpaces < ActiveRecord::Migration[6.0]
  def change
    create_table :game_spaces do |t|
      t.int :space_id
      t.int :game_id
      t.int :placement_order
      t.int :rent_level

      t.timestamps
    end
  end
end
