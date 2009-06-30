class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :title
      t.string :route
      t.boolean :require_id, :default => true
      t.boolean :visible, :default => true
      t.integer :parent_id
      t.string :method
      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end