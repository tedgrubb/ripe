class AddExpiresAtToPantryIngredients < ActiveRecord::Migration
  def self.up
    add_column :pantry_ingredients, :expires_at, :timestamp
  end

  def self.down
    remove_column :pantry_ingredients, :expires_at
  end
end
