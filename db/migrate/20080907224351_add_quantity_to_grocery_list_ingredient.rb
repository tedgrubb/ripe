class AddQuantityToGroceryListIngredient < ActiveRecord::Migration
  def self.up
    add_column :grocery_list_ingredients, :quantity, :integer
  end

  def self.down
    drop_column :grocery_list_ingredients, :quantity
  end
end
