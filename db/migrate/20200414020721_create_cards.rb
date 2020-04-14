class CreateCards < ActiveRecord::Migration[6.0]
  def change
    create_table :cards do |t|
      t.string :card_name
      t.string :card_text
      t.string :card_type

      t.timestamps
    end
  end
end
