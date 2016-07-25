class AddRecipeIdToSteps < ActiveRecord::Migration
  def self.up
    add_column :steps, :recipe_id, :integer
  end

  def self.down
    drop_column :steps, :recipe_id
  end
end
