config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
# ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config['test'])

class CreateSchema < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.column :name, :string
    end
    
    create_table :taggings do |t|
      t.column :tag_id, :integer
      t.column :taggable_id, :integer
      t.column :tagger_id, :integer
      t.column :tagger_type, :string
      
      # You should make sure that the column created is
      # long enough to store the required class names.
      t.column :taggable_type, :string
      t.column :context, :string
      
      t.column :created_at, :datetime
    end
    
    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type, :context]
  end
end

CreateSchema.suppress_messages { CreateSchema.migrate(:up) }