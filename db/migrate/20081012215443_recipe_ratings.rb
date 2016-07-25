class RecipeRatings < ActiveRecord::Migration
  def self.up
    create_table :recipe_ratings do |t|
      t.integer :user_id
      t.integer :recipe_id
      t.integer :score
      t.timestamps
    end
  end

  def self.down
    drop_table :recipe_ratings
  end
end
