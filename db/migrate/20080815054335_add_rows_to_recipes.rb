class AddRowsToRecipes < ActiveRecord::Migration
  def self.up
    add_column :recipes, :description, :text
    add_column :recipes, :cuisine, :string
  end

  def self.down
    remove_column :recipes, :description
    remove_column :recipes, :cuisine
  end
end
