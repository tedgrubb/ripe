class AddInviteDetailsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :inviter_id, :integer
    add_column :users, :invites, :integer
  end

  def self.down
    remove_column :users, :inviter_id
    remove_column :users, :invites
  end
end