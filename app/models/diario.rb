class Diario < ActiveRecord::Base

	belongs_to :zona, :foreign_key=>'zona_id'


#restricciones/validaciones
	validates :zona_id, :fecha, :presence => true

        validates_uniqueness_of :fecha, :scope => :zona_id

end
