class CreateProperties < ActiveRecord::Migration[6.0]
  def change
    create_table :properties do |t|
      t.int :player_id
      t.int :game_id
      t.int :space_id

      t.timestamps
    end
  end
end
