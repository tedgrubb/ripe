class RenameRecipeStepText < ActiveRecord::Migration
  def self.up
    rename_column :recipes, :steps, :text_steps
  end

  def self.down
    rename_column :recipes, :text_steps, :steps
  end
end
