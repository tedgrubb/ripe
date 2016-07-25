class CreateRecipes < ActiveRecord::Migration
  def self.up
    create_table :recipes do |t|
      t.string :name
      t.string :time
      t.string :steps
      t.string :note
      t.integer :servings
      t.timestamps
    end
  end

  def self.down
    drop_table :recipes
  end
end
