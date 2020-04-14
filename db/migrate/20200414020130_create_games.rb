class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :game_name
      t.boolean :is_started
      t.boolean :is_finished
      t.int :turn_count

      t.timestamps
    end
  end
end
