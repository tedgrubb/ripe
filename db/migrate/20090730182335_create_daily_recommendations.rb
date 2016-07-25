class CreateDailyRecommendations < ActiveRecord::Migration
  def self.up
    create_table :daily_recommendations, :force => true do |t|
      t.integer :recipe_id
      t.integer :user_id
      t.boolean :followed, :default => false
      t.boolean :clicked, :default => false
      t.integer :precision, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :daily_recommendations
  end
end
