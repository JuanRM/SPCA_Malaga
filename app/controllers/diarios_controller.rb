class DiariosController < ApplicationController


#####################################
  # Muestra información de un día
  #   HORARIOS->
  #   -> add_informe, adittareadia, edit
  #   -> ZONAS.editar_tareas
#####################################

  def show

    @hoy=Date.today

    if params[:fecha]!=nil
       @dia = Date.parse(params[:fecha])
       #@dia=params[:fecha]
       @zona=params[:zona]
       @diario = Diario.find(:all, :conditions => ["fecha = ? AND zona_id = ?", @dia, @zona]).first
    else
       @diario = Diario.find(params[:id])
    end


    if @dia.nil?
       @dia= @diario.fecha.strftime("%d-%m-%Y")
       if @dia.nil?
          @dia=Date.today
       end	
    end
    @date=Date.today
#-----------------------------------------------------------
#    @semana = @date-7
    @ayer = @date-1
#---------------------------------------------
    if @diario.nil?
	@diario=Diario.new
        flash[:notice] = 'No existe tareas ni informes para este dia .'
	redirect_to :action=>"new", :fecha=>@dia, :zona=>@zona    
    else
	@zona = @diario.zona 
        @zonas = Zona.find(:all, :conditions => ["id != ?", 14])  
	@persona=current_persona
	@nombre = @persona.id
	@Ocu = current_persona.ocupacion_id
	@currentOcu = current_persona.ocupacion
	@ocus = Ocupacion.all

        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @diario }
        end
    end

end  



#####################################
  # Informa que no existe dia
  #   HORARIO.vistahorario / HORARIO.index->
  #   show ->
  #   -> create 
#####################################

  def new

    @zonas = Zona.find(:all, :conditions => ["id != ?", 14])  
    @Ocu = current_persona.ocupacion_id
    @diario = Diario.new
    $fecha = params[:fecha]
    $zona = params[:zona]
    @zona = Zona.find(params[:zona])
    @persona=current_persona

    #@diario.fecha = params[:fecha]
    #@diario.zona_id = params[:zona]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @diario }
    end

  end



#####################################
  # Añade informe a un día
  #  show->
  #  -> show
#####################################

  def add_informe

    @diario = Diario.find(params[:id])
    @hoy=Date.today 

  end



#####################################
  # Edita los informes de un dia
  #   show ->
  #   -> show 
#####################################

  def edit

    @diario = Diario.find(params[:id])

  end



#####################################
  # Edita las tareas del dia para un dia
  #   show ->
  #   -> show
#####################################

  def edittareadia
    @diario = Diario.find(params[:id])
  end



######################################################
  #  Crea dia nuevo para una fecha y zona
  #    HORARIO.vistahorario / HORARIO.index ->
  #    show-> 
  #    -> show
######################################################

  def create

    @diario = Diario.new(params[:diario])
    @diario.zona_id = $zona
    @diario.fecha = $fecha
    @hoy=Date.today

  if  @diario.zona_id==14
        flash[:alert] = 'No esta permitido crear dias para la zona intercambio .'
        redirect_to :controller=>"horarios", :action=>"vistahorario"
  else

    #controla creación dias anterios a semana pasada
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
    
    if @diario.fecha < @semanapasada 
        flash[:alert] = 'No esta permitido crear dias anteriores a la semana pasada .'
        redirect_to :controller=>"horarios", :action=>"vistahorario"
    else

      respond_to do |format|
        if @diario.save
            format.html { redirect_to @diario, notice: 'Dia creado correctamente.' }
            format.json { render json: @diario, status: :created, location: @diario }
        else
          format.html { render action: "new" }
          format.json { render json: @diario.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  end



#####################################
  # normaliza saltos de linea en formato niceeditor
  # update <->
#####################################

  def normalizartexto(s)
    s=s.gsub!('<br></n>', '<br>')
  end

  def normalizartexto2(s)
    s=s.gsub!('</n>', '<br>')
  end



#####################################
  # Guarda datos nuevos en una zona
  #  edit / edittareadia / add_informe ->
  #  -> show
#####################################

  def update

    @diario = Diario.find(params[:id])
    @nombre = current_persona.nombre

    respond_to do |format|


      if @diario.update_attributes(params[:diario])
        format.html { redirect_to @diario, notice: 'Cambios guardados correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @diario.errors, status: :unprocessable_entity }
      end

      # si informe mañana nuevo
      if !@diario.nuevoI.nil? && !@diario.nuevoI.empty?
	if @diario.informe.nil? || @diario.informe.empty?
		@diario.informe= @nombre+": "+@diario.nuevoI
		@diario.nuevoI=""
		@diario.save  		  	
	else
        	@diario.informe= @diario.informe+"</n>"+@nombre+": "+@diario.nuevoI
                normalizartexto(@diario.informe)	
                normalizartexto2(@diario.informe)	
		@diario.nuevoI=""
		@diario.save
	end
      end

      # si informe tarde nuevo
      if !@diario.nuevo.nil? && !@diario.nuevo.empty?
	if @diario.informet.nil? || @diario.informet.empty?
		@diario.informet= @nombre+": "+@diario.nuevo
		@diario.nuevo=""
		@diario.save  		  	
	else
        	@diario.informet= @diario.informet+"</n>"+@nombre+": "+@diario.nuevo
                normalizartexto(@diario.informet)
                normalizartexto2(@diario.informet)
		@diario.nuevo=""
		@diario.save
	end

      end 

    end

  end


#####################################
  # Elimina un día del sistema
  #   Horarios.mantenimiento ->
#####################################

  def destroy

    @diario = Diario.find(params[:id])
    @diario.destroy

    respond_to do |format|
      format.html { redirect_to diarios_url }
      format.json { head :no_content }
    end

  end



end
