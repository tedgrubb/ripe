class CreateCuisinePreferences < ActiveRecord::Migration
  def self.up
    create_table :cuisine_preferences do |t|
      t.integer :user_id
      t.integer :cuisine_id
      t.timestamps
    end
  end

  def self.down
    drop_table :cuisine_preferences
  end
end
