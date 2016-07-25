class AddTextToRecipes < ActiveRecord::Migration
  def self.up
    remove_column :recipes, :steps
    remove_column :recipes, :note
    add_column :recipes, :steps, :text
    add_column :recipes, :note, :text
  end

  def self.down
    remove_column :recipes, :steps
    remove_column :recipes, :note
  end
end
