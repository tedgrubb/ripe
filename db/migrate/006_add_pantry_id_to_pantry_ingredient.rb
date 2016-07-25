class AddPantryIdToPantryIngredient < ActiveRecord::Migration
  def self.up
    add_column :pantry_ingredients, :pantry_id, :integer
  end

  def self.down
    remove_column :pantry_ingredients, :pantry_id
  end
end
