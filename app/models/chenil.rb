# == Schema Information
#
# Table name: chenils
#
#  id         :integer         not null, primary key
#  zona_id    :integer
#  ocupado    :integer
#  capacidad  :integer
#  caplibre   :integer
#  notas      :text
#  estado     :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  numero     :integer
#

class Chenil < ActiveRecord::Base

attr_accessible :numero, :ocupado, :capacidad, :caplibre, :zona_id, :notas, :estado, :nuevoNC, :Informacion


attr_accessible :numero

	belongs_to :zona, :foreign_key=>'zona_id'

	has_many :animals

#restricciones/validaciones
	validates :zona_id, :presence => true

	validates :numero, :presence => {:message => "no puede estar vacio"},
                  :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :message => "valor debe estar entre 0 y 100" }

	validates :capacidad, :presence => {:message => "no puede estar vacio"},
                  :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :message => "valor debe estar entre 0 y 100" }


end
