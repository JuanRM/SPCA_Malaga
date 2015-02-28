# == Schema Information
#
# Table name: animals
#
#  id                :integer         not null, primary key
#  nombre            :string(255)
#  raza              :string(255)
#  sexo              :string(255)
#  fecha_entrada     :date
#  observaciones     :text
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  foto_file_name    :string(255)
#  foto_content_type :string(255)
#  foto_file_size    :integer
#  foto_updated_at   :datetime
#  chenil_id         :integer
#

class Animal < ActiveRecord::Base
     attr_accessible :nombre, :raza, :sexo, :fecha_entrada, :observaciones, 
:chenil_id, :foto, :veterinario, :notas, :especie_id, :zona_id, 
:edad, :nuevoNA

  belongs_to :chenil, :foreign_key=>'chenil_id'  

  belongs_to :especie, :foreign_key=>'especie_id'

  belongs_to :zona, :foreign_key=>'zona_id'

   #relacion muchos_a_muchos consigo misma 
   has_many(:relacion_animals, :foreign_key => :animal1_id, :dependent => :destroy)

   has_many(:reverse_relacion_animals, :class_name => :RelacionAnimal, :foreign_key => :animal2_id, :dependent => :destroy)

   has_many :animals, :through => :relacion_animals, :source => :animal2_id


   # Restricciones datos
   validates :zona_id, :presence => true

   validates :chenil_id, :presence => true

   validates :nombre, 
    :presence => {:message => "no puede estar vacio"},
    :length => { :in => 2..30, :message => " ERROR, longitud entre 2 y 30 caracteres" }

   validates :raza, :length => { :maximum => 25, :message => " ERROR, maximo 25 caracteres" }


  # Paperclip
  has_attached_file :foto,
		:styles => {
                      :thumb => "100x100>",
                      :medium => "300x300"
                 }



#definiciones busquedas
def self.search1(search)
    if (search)
      find(:all, :conditions => ['nombre LIKE ?', "%#{search}%"])
    else
      find(:all, :order => "nombre asc")
    end
end

def self.search4(search)
    if (search)
      find(:all, :conditions => ['raza LIKE ?', "%#{search}%"])
    else
      find(:all, :order => "raza asc, nombre asc")
    end
end

def self.search5(search)
    if (search)
       find(:all, :conditions => ["zona_id = ?", "#{search}"], :order => "nombre asc")
    else
      find(:all, :order => "zona_id asc, nombre asc")
    end
end

def self.search6(search)
    if (search)
       find(:all, :conditions => ["especie_id = ?", "#{search}"])
    else
      find(:all, :order => "especie_id asc")
    end
end

def self.search7(search)
    if (search)
       find(:all, :conditions => ["sexo LIKE ?", "%#{search}%"], :order => "nombre asc")
    else
      find(:all, :order => "sexo asc, nombre asc")
    end
end


def animals
  @animales ||= find_animals
end


private

def find_animals
  Animal.find(:all, :conditions => conditions)
end

def name_conditions
  ["animals.nombre LIKE ?", "%#{nombre}%"] unless nombre.blank?
end


def category_conditions
  ["animals.chenil_id = ?", zona_id] unless zona_id.blank?
end

def conditions
  [conditions_clauses.join(' AND '), *conditions_options]
end

def conditions_clauses
  conditions_parts.map { |condition| condition.first }
end

def conditions_options
  conditions_parts.map { |condition| condition[1..-1] }.flatten
end

def conditions_parts
  private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
end

end
