class Especie < ActiveRecord::Base
  attr_accessible :nombre

  has_many :animals

validates :nombre, 
    :presence => {:message => "no puede estar vacio"},
    :uniqueness => { :case_sensitive => true },
    :length => { :in => 4..20, :message => " ERROR, longitud entre 4 y 20 caracteres" }

end
