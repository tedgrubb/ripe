class RecipeSteps < ActiveRecord::Migration
  def self.up
    create_table :recipe_steps do |t|
      t.integer :step_id

      t.timestamps
    end
  end

  def self.down
    drop_table :recipe_steps
  end
end
