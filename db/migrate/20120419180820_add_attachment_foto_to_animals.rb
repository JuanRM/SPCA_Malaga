class AddAttachmentFotoToAnimals < ActiveRecord::Migration
  def self.up
    add_column :animals, :foto_file_name, :string
    add_column :animals, :foto_content_type, :string
    add_column :animals, :foto_file_size, :integer
    add_column :animals, :foto_updated_at, :datetime
  end

  def self.down
    remove_column :animals, :foto_file_name
    remove_column :animals, :foto_content_type
    remove_column :animals, :foto_file_size
    remove_column :animals, :foto_updated_at
  end
end
