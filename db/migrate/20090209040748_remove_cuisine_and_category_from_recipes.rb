class RemoveCuisineAndCategoryFromRecipes < ActiveRecord::Migration
  def self.up
    remove_column :recipes, :cuisine
    remove_column :recipes, :category
  end

  def self.down
    add_column :recipes, :cuisine, :string
    add_column :recipes, :category, :string
  end
end
