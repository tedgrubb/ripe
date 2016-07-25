class AddLocationToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :location, :string
  end

  def self.down
    drop_column :users, :location
  end
end
