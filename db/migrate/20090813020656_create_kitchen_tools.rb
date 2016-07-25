class CreateKitchenTools < ActiveRecord::Migration
  def self.up
    create_table :kitchen_tools, :force => true do |t|
      t.string :name
      t.string :buy_link
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :kitchen_tools
  end
end
