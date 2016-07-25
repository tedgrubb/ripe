class AddBaseToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :basic, :boolean
  end

  def self.down
    remove_column :categories
  end
end
