class CreatePantryMemberships < ActiveRecord::Migration
  def self.up
    create_table :pantry_memberships do |t|
      t.integer :user_id
      t.integer :pantry_id
      t.timestamps
    end
  end

  def self.down
    drop_table :pantry_memberships
  end
end
