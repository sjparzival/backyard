class AddFireToBlocks < ActiveRecord::Migration[5.0]
  def change
    add_column :blocks, :fire, :string
  end
end
