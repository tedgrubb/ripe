class GroceryListIngredients < ActiveRecord::Migration
  def self.up
    create_table :grocery_list_ingredients do |t|
      t.integer :grocery_list_id
      t.integer :ingredient_id
      t.timestamps
    end
  end

  def self.down
    drop_table :grocery_list_ingredients
  end
end
