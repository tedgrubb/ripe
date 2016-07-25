class AddViewCountToRecipes < ActiveRecord::Migration
  def self.up
    add_column :recipes, :views, :integer
  end

  def self.down
    remove_column :recipes, :views
  end
end
