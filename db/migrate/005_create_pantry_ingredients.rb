class CreatePantryIngredients < ActiveRecord::Migration
  def self.up
    create_table :pantry_ingredients do |t|
      t.integer :ingredient_id

      t.timestamps
    end
  end

  def self.down
    drop_table :pantry_ingredients
  end
end
