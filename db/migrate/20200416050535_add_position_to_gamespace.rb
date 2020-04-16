class AddPositionToGamespace < ActiveRecord::Migration[6.0]
  def change
    add_column :game_spaces, :position, :integer
  end
end
