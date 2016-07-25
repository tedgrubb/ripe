class CreateIngredientCategories < ActiveRecord::Migration
  def self.up
    create_table :ingredient_categories do |t|
      t.integer :category_id
      t.integer :ingredient_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ingredient_categories
  end
end
