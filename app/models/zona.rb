# == Schema Information
#
# Table name: zonas
#
#  id         :integer         not null, primary key
#  nombre     :string(255)
#  notas      :string(255)
#  text       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Zona < ActiveRecord::Base

attr_accessible :nombre, :notas, :text, :nuevoNZ, :tareas

	has_many :chenils, :dependent => :destroy

	has_many :animals
        
        has_many :horarios, :dependent => :destroy

        has_many :diarios, :dependent => :destroy

        has_many :personas, :dependent => :destroy 

	validates :nombre, :presence => {:message => "no puede estar vacio"},
		  :length => { :maximum => 25, :message => " ERROR, maximo 25 caracteres" }
        
end
