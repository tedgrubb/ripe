class CreateRecipeCuisines < ActiveRecord::Migration
  def self.up
    create_table :recipe_cuisines do |t|
      t.integer :recipe_id
      t.integer :cuisine_id
      t.timestamps
    end
  end

  def self.down
    drop_table :recipe_cuisines
  end
end
