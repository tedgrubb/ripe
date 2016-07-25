class GroceryListMemberships < ActiveRecord::Migration
  def self.up
    create_table :grocery_list_memberships do |t|
      t.integer :user_id
      t.integer :grocery_list_id
      t.timestamps
    end
  end

  def self.down
    drop_table :grocery_list_memberships
  end
end
