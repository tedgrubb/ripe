class AddImportContentToRecipes < ActiveRecord::Migration
  def self.up
    add_column :recipes, :import_content, :text
  end

  def self.down
    remove_column :recipes, :import_content
  end
end
