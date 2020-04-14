class CreateSpaces < ActiveRecord::Migration[6.0]
  def change
    create_table :spaces do |t|
      t.string :space_name
      t.integer :space_cost
      t.integer :rent_level1
      t.string :group
      t.string :space_type
      t.integer :default_position

      t.timestamps
    end
  end
end
