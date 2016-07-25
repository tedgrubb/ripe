class AddKeepTimeToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :keep_time, :integer
  end

  def self.down
    remove_column :categories, :keep_time
  end
end
