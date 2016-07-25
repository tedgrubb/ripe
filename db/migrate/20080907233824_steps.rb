class Steps < ActiveRecord::Migration
  def self.up
    create_table :steps do |t|
      t.integer :number
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :steps
  end
end
