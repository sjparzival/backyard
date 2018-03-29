class AddIceToBlocks < ActiveRecord::Migration[5.0]
  def change
    add_column :blocks, :ice, :integer
  end
end
