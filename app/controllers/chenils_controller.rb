class ChenilsController < ApplicationController
 
before_filter :authenticate
#, :except => [:index, :show]
before_filter :usuario_coordinador, :only => [:destroy, :new, :edit]


#######################################################
# Meter cheniles de zonas aqui!!!!
#####################################
# Utiliza funcion:cheniles, controlador:zona para mostrar listado de cheniles
# -> "show"
# -> "new"
#####################################
  def index
    redirect_to :controller=>'zonas', :action=>"cheniles"
  end



#####################################
# Muestra la ficha de un chenil
#   index-> ###############################################
#   -> añadir nota
#   -> editar chenil
#####################################

  def show
    @chenil = Chenil.find(params[:id])
    @animals= Animal.find(:all, :conditions =>["chenil_id = ?", @chenil.id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @chenil }
    end
  end


#####################################
# Añade nota a un chenil 
#  show->
#####################################

  def add_nota
    @chenil = Chenil.find(params[:id])
  end



#####################################
# Edita información de un chenil
#  show->
#####################################

  def edit
    @chenil = Chenil.find(params[:id])
  end



#####################################
# Crea chenil nuevo
#   index->############################################
#####################################

  def new
    @chenil = Chenil.new
    @zonas = Zona.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @chenil }
    end
  end


#####################################
# Guarda chenil nuevo
#   invoca función "new" para recoger datos
#####################################

  def create
    @chenil = Chenil.new(params[:chenil])
#    @chenil.ocupado = 0
    @chenil.zona_id=current_persona.zona_id
    @chenil.caplibre=@chenil.capacidad


    #controlar "no duplicado de numero de chenil" en la misma zona
    @chenilcontrol = Chenil.find(:all, :conditions => ["zona_id = ? AND numero = ?", @chenil.zona_id, @chenil.numero]).first

    if @chenilcontrol.nil?

      respond_to do |format|
        if @chenil.save
          format.html { redirect_to @chenil, notice: 'Creado chenil nuevo.' }
          format.json { render json: @chenil, status: :created, location: @chenil }
        else
          format.html { render action: "new" }
          format.json { render json: @chenil.errors, status: :unprocessable_entity }
        end
      end

    else
       flash[:alert] = "Chenil no pudo ser creado, ya exite un chenil con ese numero para su zona"
       render :action => :new
    end

  end



#####################################
# Guarda datos nuevos en un chenil
#  edit->
#  add_nota->
#####################################
#################################################QUITAR EDITOR EXTENDIDO

  def update

    @chenil = Chenil.find(params[:id])
    @capacidad = @chenil.capacidad
    @numero = @chenil.numero
    @nombre = current_persona.nombre #????
    @date= Date.today.to_s
    if @chenil.capacidad<0
       @chenil.capacidad=0
    end

    respond_to do |format|

      if @chenil.update_attributes(params[:chenil])

         #controlar "no duplicado de numero de chenil" en la misma zona
         @chenilcontrol = Chenil.find(:all, :conditions => ["zona_id = ? AND numero = ?", @chenil.zona_id, @chenil.numero]).second
         if !@chenilcontrol.nil?
              @chenil.numero = @numero
              @chenil.capacidad = @capacidad
              @chenil.save
              flash[:alert] = "Chenil no pudo ser modificado, ya exite un chenil con ese numero para su zona"
              format.html { redirect_to @chenil }
              format.json { head :no_content }
         else
             #control coherencia capacidad chenil y capacidad nula
             if @chenil.capacidad < @chenil.ocupado 
                 @chenil.capacidad=@chenil.ocupado
                 @chenil.caplibre=0
                 @chenil.save
                 flash[:alert] = "Incoherencia en la capacidades del chenil resuelta, la capacidad no puede ser menor al numero de animales alojados."
                 format.html { redirect_to @chenil }
                 format.json { head :no_content }
             else
                #Controles corrector = modificación correcta
                format.html { redirect_to @chenil, notice: 'Chenil modificado correctamente.' }
                format.json { head :no_content }
             end
         
         end

      #error al modificar entidad
      else
        format.html { render action: "edit" }
        format.json { render json: @chenil.errors, status: :unprocessable_entity }
      end


      #si se añadió nota nueva
      if !@chenil.nuevoNC.nil? && !@chenil.nuevoNC.empty?
	if @chenil.notas.nil? || @chenil.notas.empty? 
		@chenil.notas= @date+" / "+@nombre+":  "+@chenil.nuevoNC
		@chenil.nuevoNC=""
		@chenil.save  		  	
	else
        	@chenil.notas= @chenil.notas+"\n"+@date+" / "+@nombre+":  "+@chenil.nuevoNC
		@chenil.nuevoNC=""
		@chenil.save
	end
      end


   end
  end


#####################################
# Elimina chenil del sistema
#   show->
#####################################

  def destroy
    @chenil = Chenil.find(params[:id])
    if (@chenil.zona_id!=current_persona.zona_id || (current_persona.ocupacion_id!=1 && current_persona.ocupacion_id!=3))
       flash[:alert] = 'Acceso no permitido, Los cheniles solo pueden ser eliminados por Coordinadores y Veterinarios en sus modulos.'
       redirect_to :action=>"show", :id=> @chenil.id
    else
      @animals=Animal.find(:first, :conditions => ["chenil_id = ?", @chenil.id])
      if (!@animals.nil?)
         flash[:alert] = 'No puede eliminar un chenil con animales dentro, mueva o borre los animales antes de eliminar el chenil.'
         redirect_to :action=>"show", :id=> @chenil.id
      else
         @chenil.destroy

        respond_to do |format|
	  format.html { redirect_to :controller=>"zonas", :action=>"cheniles" }
          format.json { head :no_content }
        end
      end

    end
  end



###################################
# Asignación ocupaciones a permisos
###################################

private

	def usuario_coordinador
	   deny_destroy unless (current_persona.ocupacion_id==1 || current_persona.ocupacion_id==3)
	end

        def deny_destroy
    	   store_location
    	   redirect_to (zonas_path), :notice => "Necesitas permisos de coordinador/veterinario para dar de alta/baja un chenil."
  	end

end
