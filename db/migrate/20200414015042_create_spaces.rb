class CreateSpaces < ActiveRecord::Migration[6.0]
  def change
    create_table :spaces do |t|
      t.string :space_name
      t.int :space_cost
      t.int :rent_level1
      t.string :group
      t.string :type

      t.timestamps
    end
  end
end
