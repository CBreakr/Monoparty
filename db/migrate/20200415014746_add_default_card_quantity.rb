class AddDefaultCardQuantity < ActiveRecord::Migration[6.0]
  def change
    add_column :cards, :default_quantity, :integer
  end
end
