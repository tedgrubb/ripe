class AddNameToGroceryLists < ActiveRecord::Migration
  def self.up
    add_column :grocery_lists, :name, :string
  end

  def self.down
    drop_column :grocery_lists, :name
  end
end
