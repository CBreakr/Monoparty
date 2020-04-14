class AddCardMethodName < ActiveRecord::Migration[6.0]
  def change
    add_column :cards, :method_name, :string
  end
end
