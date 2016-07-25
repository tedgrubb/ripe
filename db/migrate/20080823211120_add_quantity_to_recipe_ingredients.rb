class AddQuantityToRecipeIngredients < ActiveRecord::Migration
  def self.up
    add_column :recipe_ingredients, :entered_quantity, :string
    rename_column :recipe_ingredients, :amount, :parsed_quantity
  end

  def self.down
    drop_column :recipe_ingredients, :entered_quantity
    rename_column :recipe_ingredients, :parsed_quantity, :amount
  end
end
