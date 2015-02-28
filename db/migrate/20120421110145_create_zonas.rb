class CreateZonas < ActiveRecord::Migration
 # def self.up
  def change
    create_table :zonas do |t|
   #   t.varchar(25) :nombre
      t.string "nombre", :limit => 25
      t.string :notas
      t.string :text

      t.timestamps
    end
  end
end
