class AddIngredientCountToRecipe < ActiveRecord::Migration
  class Recipe < ActiveRecord::Base
    has_many :recipe_ingredients
  end
  class RecipeIngredient < ActiveRecord::Base ; end
  
  def self.up
    add_column :recipes, :recipe_ingredients_count, :integer, :default => 0
    Recipe.all.each do |recipe|
      recipe.update_attribute :recipe_ingredients_count, recipe.recipe_ingredients.count
    end
  end

  def self.down
    remove_column :recipes, :recipe_ingredients_count
  end
end
