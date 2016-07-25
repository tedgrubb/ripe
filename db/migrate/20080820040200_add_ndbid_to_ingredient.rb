class AddNdbidToIngredient < ActiveRecord::Migration
  def self.up
    add_column :ingredients, :ndb_id, :string
  end

  def self.down
    remove_column :ingredients, :ndb_id
  end
end
