class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :title
      t.string :route
      t.string :method
      t.boolean :visible
      t.integer :parent_id
      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
