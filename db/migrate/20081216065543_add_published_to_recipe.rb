class AddPublishedToRecipe < ActiveRecord::Migration
  def self.up
    add_column :recipes, :published, :boolean
  end

  def self.down
    remove_column :recipes, :published
  end
end
