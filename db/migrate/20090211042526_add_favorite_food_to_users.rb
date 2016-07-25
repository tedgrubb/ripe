class AddFavoriteFoodToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :favorite_food, :string
  end

  def self.down
    remove_column :users, :favorite_food
  end
end
