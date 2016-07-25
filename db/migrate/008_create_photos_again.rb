class CreatePhotosAgain < ActiveRecord::Migration
  def self.up
    drop_table :photos
    create_table :photos do |t|
      t.column :filename, :string
      t.column :size, :integer
      t.column :content_type, :string
      t.column :thumbnail, :string
      t.column :parent_id, :integer
      t.column :height, :integer
      t.column :width, :integer

      # Magic is here
      t.column :owner_id, :integer
      t.column :owner_type, :string
    end
  end

  def self.down
    drop_table :photos
  end
end
