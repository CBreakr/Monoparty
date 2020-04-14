class AddSpaceMethodName < ActiveRecord::Migration[6.0]
  def change
    add_column :spaces, :method_name, :string
  end
end
