class AddImportSourceToRecipes < ActiveRecord::Migration
  def self.up
    add_column :recipes, :import_source, :string
    add_column :recipes, :import_url, :string
  end

  def self.down
    remove_column :recipes, :import_source
    remove_column :recipes, :import_url
  end
end
