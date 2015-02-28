class HorariosController < ApplicationController

  # GET /horarios
  # GET /horarios.json
  before_filter :authenticate


#############################################
# PRINCIPAL HORARIOS
#   CALENDARIO 3 SEMANAS: Muestra turnos asignados a una zona
#    (solo desde) menu -> 
#    -> elegir turnos / asignar turnos
#    -> ver información dia / ver informes semana 
#    -> (AUTO) unificación turnos/dias dos semanas antiguos 
#############################################

  def vistahorario

    @persona=current_persona
    @zona=@persona.zona
    @ocupacion=@persona.ocupacion
    @hoy=Date.today  
    @zonas = Zona.find(:all, :conditions => ["id != ?", 14])  



   # MANTENIMIENTO: DISPARADOR UNIFICACIÓN (zona propia)
   #   Si fecha unificacion anterior a 2 semanas
   #   -> Lanza unificador semanal de turnos e informes para la zona
   #   vistahorario -> unificacionturnos -> unificacion -> vistahorario
   ###############################################

   #-comprueba que existe fecha de unificación
   #-sino la actualiza a 4 semanas antes
    if @zona.fechaunif==nil
	@zona.fechaunif=@hoy-28
	@zona.save
    end

   #si 2 meses sin entrar nadie al horario del módulo
    if (@hoy-@zona.fechaunif)>56
	@zona.fechaunif=@hoy-56
        @zona.save
    end

   #si dos semanas desde fecha unificacion
    if @hoy - @zona.fechaunif >13 

       #Si fecha unificicacion distinto de lunes
        @fechaunificacion = @zona.fechaunif
    	@diasemana=@fechaunificacion.wday

    	if @diasemana!=1
	   if @diasemana==0
		@fechalunes=@fechaunificacion+1
		@zona.fechaunif=@fechalunes
		@zona.save
	   else	
  		@fechalunes=@fechaunificacion-(@diasemana-1)
		@zona.fechaunif=@fechalunes
		@zona.save
           end	
        end	

    	#UNIFICACIÓN TURNOS de 1 SEMANA
    	# -> UNIFICACION DIAS de 1 SEMANA
	#unificacionturnos
        return redirect_to :action=>"unificacionturnos"

    end


   # MANTENIMIENTO: BORRADO DIAS/TURNOS ANTIGUOS
   #  Si DIAS anterior a 12 semanas
   #  Si turnos anterior a 4semanas
   #  -> Los borra automaticamente
   #####################################

    if params[:zona]!=nil
       @zona = Zona.find(params[:zona])
    end

    @docesemanas=@hoy-84
    @cuatrosemanas=@hoy-28

  
    @diariosantiguos = Diario.find(:all, :conditions=>["zona_id = ? AND fecha <= ?", @zona.id, @docesemanas])

    @diariosantiguos.each do |diaantiguo|
	diaantiguo.destroy
    end
    
    @turnosantiguos = Horario.find(:all, :conditions=>["zona_id = ? AND fecha <= ?", @zona.id, @cuatrosemanas])

    @turnosantiguos.each do |turnoantiguo|
	turnoantiguo.destroy
    end

   #####################################


    if @hoy.wday!=1
      if @hoy.wday==0
          @lunes=@hoy-6
      else
          @diasemana=@hoy.wday
          @lunes = @hoy-(@diasemana-1)
      end
    else
       @lunes = @hoy
    end

    @semanapasada = @lunes-7
    @semanasiguiente= @lunes+13

    @horarios = Horario.find(:all, :conditions=>["zona_id = ? AND fecha <= ? and fecha >= ?", @zona.id, @semanasiguiente, @semanapasada])
    @diarios = Diario.find(:all, :conditions=>["zona_id = ? AND fecha <= ? and fecha >= ?", @zona.id, @semanasiguiente, @semanapasada])

#@diarios = Diario.find(:all, :conditions => ["zona_id = ? AND fecha > ? AND fecha < ?", @zona, @iniciosemana, @finsemana+1], :order => "fecha ASC")

  end



#############################################
# HORARIOS
#   CALENDARIO MES COMPLETO: Muestra turnos asignados a una zona
#    vistahorario / index -> 
#    -> elegir turnos / asignar turnos
#    -> ver información dia / ver informes semana 
#############################################

  def index

    @persona = current_persona
    @zona = @persona.zona
    @date=Date.today
    @ocupacion = @persona.ocupacion

    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @hoy = Date.today

#???????????????????????????????
#?  @dianuevo=Date.today+15
#?  @zonanuevo=current_persona.zona.id
   # @diario.fecha=@dianuevo
   # @diario.zona_id==@zonanuevo 
#???????????????????????????????????????
 

#todas las zonas menos intercambio
    @zonas = Zona.find(:all, :conditions => ["id != ?", 14])  


   # MANTENIMIENTO: BORRADO DIAS/TURNOS ANTIGUOS (zona visitada)
   #  Si DIAS anterior a 12 semanas
   #  Si turnos anterior a 4semanas
   #  -> Los borra automaticamente
   #####################################

    if params[:zona]!=nil
       @zona = Zona.find(params[:zona])
    end

    @docesemanas=@hoy-84
    @cuatrosemanas=@hoy-28

  
    @diariosantiguos = Diario.find(:all, :conditions=>["zona_id = ? AND fecha <= ?", @zona.id, @docesemanas])

    @diariosantiguos.each do |diaantiguo|
	diaantiguo.destroy
    end
    
    @turnosantiguos = Horario.find(:all, :conditions=>["zona_id = ? AND fecha <= ?", @zona.id, @cuatrosemanas])

    @turnosantiguos.each do |turnoantiguo|
	turnoantiguo.destroy
    end

   #####################################    


    @horarios = Horario.where("zona_id = ?", @zona)
    @diarios = Diario.where("zona_id = ?", @zona)

#???????????????????????????????????????
    @diariovar = Diario.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @horarios }  
    end
  end



#############################################
  # Responsable asigna un turno a un colaborador de su zona
  #    vistahorario / index -> 
  #    -> crearturnodatos
#############################################

  def asignar_turno

       @persona = current_persona
       @ocupacion = @persona.ocupacion
       @horario = Horario.new
   #    @zonas = Zona.all
       @zona = current_persona.zona_id

       @fecha = Date.parse(params[:fecha])
       @date = params[:fecha] ? Date.parse(params[:fecha]) : Date.today
       @tarde = params[:tarde]

       @guardados = Horario.find(:all, :conditions => ["fecha = ? AND zona_id = ? AND tarde = ?", @fecha, @zona, @tarde ])	       

       if !@guardados.empty?  
		@personasasignables= Persona.find(:all, :conditions =>["zona_id = ? AND (ocupacion_id = ? OR ocupacion_id = ?) AND id not in (?)", @zona, 2, 5, @guardados.map(&:persona_id)])
       else
		@personasasignables= Persona.find(:all, :conditions =>["zona_id = ? AND (ocupacion_id = ? OR ocupacion_id = ?)", @zona, 2, 5])
       end	

        @zona = Zona.find(params[:zona])
 #      @horarios = Horario.where("zona_id = ?", @zona)
 #       @hoy=Date.today

  end


######################################################
#  Crea turno asignado/elegido a/por un usuario, fecha y zona
#    asignar_turno/vista_horario/index -> 
#    -> vistahorario/index
######################################################

  def crearturnodatos

       @fecha =	Date.parse(params[:fecha])
       @date = params[:fecha] ? Date.parse(params[:fecha]) : Date.today
       @persona = params[:persona]
       @tarde = params[:tarde]
       @zona = current_persona.zona_id
       @hoy = Date.today
       @usuario = current_persona

    #si usuario no es coordinador ni veterinario, asignarle el turno a el
       if @usuario.ocupacion_id!=1 && @usuario.ocupacion_id!=3
	  @persona = @usuario.id
       end

       @horario = Horario.new

       @horario.zona_id = @zona
       @horario.tarde = @tarde
       @horario.fecha = @fecha
       @horario.persona_id = @persona

#       @guardados = Horario.find(:all, :conditions => ["fecha = ?", @fecha])
       @existe = Horario.find(:all, :conditions => ["fecha = ? AND persona_id = ? AND tarde = ? ", @fecha, @persona, @tarde ]).first

   #control: fecha, repetido, zona no externo,intercambio,limpiadores, guardado correcto
    if @zona==11 || @zona==1 || @zona==14
       flash[:alert] = 'No esta permitido crear turnos para zonas: externo, intercambio o limpiadores .'
    else	
       if @fecha<@hoy-1
          flash[:alert] = 'No puede asignarse turno con fecha anterior a ayer .'
       else	
	   if !@existe.nil?
	 	flash[:alert] = 'Este turno ya existe!'
	   else
		if @horario.save	
	 	    flash[:notice] = 'Turno creado correctamente.'  
		else
		    flash[:alert] = 'Error al crear turno'
		end	
	   end
       end
    end

   #control fecha para retorno
    if ( @fecha - @hoy < 10 || @hoy - @fecha > 1)
       redirect_to :action=>"vistahorario"
    else
       redirect_to :action=>"index", :zona=>@zona, :month => @fecha
    end

  end



#####################################
  # Muestra la ficha de un animal
  #   vistahorario/index->
  #   -> borrar turno (delete)
#####################################

  def show

    @horario = Horario.find(params[:id])
    @hoy=Date.today

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @horario }
    end

  end



########################################################
  # Borra turno del sistema
  #   show->
  #   -> vistahorario / index
  #   -> mantenimiento
########################################################

  def destroy

    @horario = Horario.find(params[:id])
    @fecha = @horario.fecha
    @hoy = Date.today
    @zona = @horario.zona_id	

    if @horario.destroy	
       flash[:notice] = 'Turno borrado correctamente'
    else
       flash[:alert] = 'No ha sido posible eliminar el turno'  
    end

    if ( (@fecha - @hoy).to_i < 10 || (@hoy - @fecha).to_i > 1)
        redirect_to :action=>"vistahorario"
    else
	redirect_to :action=>"index", :zona=>@zona, :month => @fecha
    end
  end


##################################################
  # Muestras los informes de la semana ordenado por dias
  #    vistahorario / index ->
  #    -> editar / añadir informe 
  #    -> informeAnteriores
##################################################

  def informeSemana

    @persona=current_persona
    @zona = Zona.find(params[:zona])

    @hoy=Date.today
    @date=(params[:fecha])
    @date=@date.to_date
    @diasemana=@date.wday

 #si domingo -> @diasemana=0
    if @diasemana==0
	@diasemana=7
    end

    @iniciosemana = @date-@diasemana
    @x=7-@diasemana
    @finsemana = @date+@x

    @diarios = Diario.find(:all, :conditions => ["zona_id = ? AND fecha > ? AND fecha < ?", @zona.id, @iniciosemana, @finsemana+1], :order => "fecha ASC")

######################3
#    @diaant = @diarios.first

  end



################################################
  # Muestra los informes guardados para las semanas anteriores (10 semanas)
  #    informeAnteriores -> 
  #    -> editar informe
################################################

  def informeAnteriores

    @persona=current_persona
    @zona=current_persona.zona
    @diarios= Diario.find(:all, :conditions =>["zona_id = ? AND unificado = ?", @zona.id, 1], :order => "fecha DESC")	

  end




#################################################
  # Permite la edición de un informe unificado
  #    informeAnteriores -> 
  #    -> editar informe
#################################################

  def editarinformeAnterior

    @persona=current_persona
    @zona=current_persona.zona
    @diario = Diario.find(params[:id])

  end


###################################################
  # guarda los turnos anteriores a 2 semanas en un campo de texto del día
  # y los borra
  # vistahorario (automatico) ->
  # -> unificación
###################################################

  def unificacionturnos

    @zona=current_persona.zona
    @date=Date.today
    @cuatrosemanas=@date-28
    @fechainicio=@zona.fechaunif
    @fechafin=@zona.fechaunif+7

    @horarios = Horario.find(:all, :conditions => ["zona_id = ? AND fecha > ? AND fecha < ?", @zona, @fechainicio-1, @fechafin], :order => "fecha ASC")

    @diarios = Diario.find(:all, :conditions => ["zona_id = ? AND fecha > ? AND fecha < ?", @zona, @fechainicio-1, @fechafin], :order => "fecha ASC")

  end

################################################
  # Unifica los 7 informes de la semana en 1 dia
  # unificaciónturnos ->
  # -> indes / vistahorario
################################################


  def unificacion

    @persona=current_persona
    @zona=current_persona.zona
    @date=Date.today
    @fechaunificacion=@zona.fechaunif

    @diarios = Diario.find(:all, :conditions => ["zona_id = ? AND fecha > ? AND fecha < ?", @zona, @fechaunificacion-1, @fechaunificacion+7], :order => "fecha ASC")

  end


##########################################

##########################################

#  def creaDiario(z,f)
#
#    @fecha = f
#    @zona = z
#
#    @diario = Diario.new
#    @diario.zona_id = @zona
#    @diario.fecha = @fecha
#
#    @diario.save
#
#  end


end

########################################################
private
    def authenticate
       deny_access unless signed_in?
    end

