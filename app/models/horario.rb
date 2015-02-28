class Horario < ActiveRecord::Base

	belongs_to :persona, :foreign_key=>'persona_id'

        belongs_to :zona, :foreign_key=>'zona_id'

	validates :zona_id, :presence => true

        validates :persona_id, :presence => true
end

#definiciones calendar
def es_month(date)
   _months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio' ,
'Julio', 'Agosto','Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
   month = date.strftime('%m')
   return _months[(month.to_i)-1]
end
