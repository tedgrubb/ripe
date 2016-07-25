class AddFeaturedAtToRecipe < ActiveRecord::Migration
  def self.up
    add_column :recipes, :featured_at, :timestamp
  end

  def self.down
    remove_column :recipes, :featured_at
  end
end
