class AddUrgeToBlocks < ActiveRecord::Migration[5.0]
  def change
    add_column :blocks, :urge, :integer
  end
end
