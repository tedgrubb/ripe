class AddSenderToInvites < ActiveRecord::Migration
  def self.up
    add_column :invites, :sender, :string
  end

  def self.down
    remove_column :invites, :sender
  end
end
