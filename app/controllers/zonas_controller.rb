class ZonasController < ApplicationController

#####################################
# Asignación permisos a funciones
#####################################

  before_filter :authenticate
  before_filter :usuario_coordinador, :only => [:edit]
  before_filter :usuario_administrador, :only => [:destroy, :new]



#####################################
# Listado de zonas existentes
# menu -> 
# -> ficha
# -> cheniles
#####################################

  def index

    @zonas = Zona.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @zonas }
    end
  end

 

#####################################
# Listado de cheniles pertenecientes a una zona 
#  - muestra animales en su interior
#  - permite ordenado y eleccion de zona
#  index -> 
#  -> crear chenil nuevo
#####################################

  def cheniles

    if params[:id]!=nil
        @zona = Zona.find(params[:id])
    else
        @zona = Zona.find(:all, :conditions => ["id = ?", current_persona.zona_id]).first
    end

#    @zonas= Zona.all
    @zonas= Zona.find(:all, :conditions => ["id != ?", 11])

    #opciones de busqueda/ordenación
    @busqueda=params[:busqueda]
    if @busqueda.nil?
       @chenils = Chenil.find(:all, :conditions => ["zona_id = ?", @zona.id], :order => "numero ASC")
    else
       if @busqueda=="Capacidad"
          @chenils = Chenil.find(:all, :conditions => ["zona_id = ?", @zona.id], :order => "capacidad desc, numero ASC")
       end
       if @busqueda=="Espacio"
          @chenils = Chenil.find(:all, :conditions => ["zona_id = ?", @zona.id], :order => "caplibre desc, numero ASC")
       end
       if @busqueda=="F.modificacion"
          @chenils = Chenil.find(:all, :conditions => ["zona_id = ?", @zona.id], :order => "updated_at desc, numero ASC")
       end
    end

  end	



#####################################
# Muestra la ficha de una zona
#   index->
#   -> añadir nota
#   -> editar zona
#   -> editar tareas
#####################################

  def show
    @zona = Zona.find(params[:id])
    @zonas = Zona.all
    @Ocu = current_persona.ocupacion_id

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @zona }
    end
  end



#####################################
# Añade una nota a una zona 
#  show->
#####################################

  def add_nota
    @zona = Zona.find(params[:id])
  end



###################################
# Edita tareas generales de una zona
#  show->
###################################

  def editar_tareas

    @zona = Zona.find(params[:zona])
    @zonas = Zona.all

   #Controlar edición tareas solo Coord/Vet su módulo
    if ((current_persona.ocupacion_id!= 1 && current_persona.ocupacion_id!= 3) || (current_persona.zona_id!=@zona.id && @zona.id!=1 && @zona.id!=11 && @zona.id!=14 ))
       flash[:notice] = 'Acceso no permitido, La edicion de tareas esta limitada a los Coordinadores y Veterinarios en sus modulos.'
       redirect_to :action=>"show", :id=> current_persona.zona_id
    end

  end



#####################################
# Edita información de una zona
#  show->
#####################################

  def edit

    @zona = Zona.find(params[:id])

#----------------------------------------------------------------------
#control edit cambio en barra de navegacion
#Coordinador/Veterinario su modulo, Administrador???
#----------------------------------------------------------------------    
    if (@zona.id!=current_persona.zona_id && @zona.id!=1 && @zona.id!=11 && @zona.id!=14)
	flash[:alert] = 'Acceso no permitido, Edicion de zona limitada a Coordinadores y Veterinarios en sus modulos.'
        redirect_to :action=>"show", :id=>@zona.id
    end
  end



#####################################
  # Guarda datos nuevos en una zona
  #  edit->
  #  add_nota->
#####################################

  def update

    @zona = Zona.find(params[:id])
    @nombre = current_persona.nombre
    @date= Date.today.to_s

    respond_to do |format|
      if @zona.update_attributes(params[:zona])
        format.html { redirect_to @zona, notice: 'Zona modificada correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @zona.errors, status: :unprocessable_entity }
      end


      #añade nombre de usuario y fecha junto a nota
      if !@zona.nuevoNZ.nil? && !@zona.nuevoNZ.empty?
	if @zona.notas.nil? || @zona.notas.empty?  #estas condiciones estan bien?? ||??
		@zona.notas= @date+" / "+@nombre+":  "+@zona.nuevoNZ
		@zona.nuevoNZ=""
		@zona.save  		  	
	else
        	@zona.notas= @zona.notas+"\n"+@date+" / "+@nombre+":  "+@zona.nuevoNZ
		@zona.nuevoNZ=""
		@zona.save
	end
      end

    end

  end



#####################################
# Listado de las zonas existentes
#  menu administrador->
#  -> crear zona nueva
#  -> eliminar zona
#####################################

  def administracionzonas

    @zonas = Zona.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @zonas }
    end

  end



#####################################
# Crea zona nueva
#   !solo administrador
#   administracionzonas->
#####################################

  def new
    @zona = Zona.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @zona }
    end
  end



#####################################
# Guarda zona nueva
#   invoca función "new" para recoger datos
#####################################

  def create
    @zona = Zona.new(params[:zona])

    respond_to do |format|
      if @zona.save
        format.html { redirect_to @zona, notice: 'Zona creada correctamente.' }
        format.json { render json: @zona, status: :created, location: @zona }
      else
        format.html { render action: "new" }
        format.json { render json: @zona.errors, status: :unprocessable_entity }
      end
    end
  end



#####################################
# Elimina zona del sistema
#   !solo administrador
#   administracionzonas ->
#####################################

  def destroy
##################################################
#OJO: """personas""", diarios, (turnos autoborrado)
##################################################

    @zona = Zona.find(params[:id])

   #no se permite eliminar las zonas Externo, Veterinario, Intercambio o Limpiadores
    if (@zona.id <= 2 || @zona.id == 11 || @zona.id == 14 )
   	 flash[:alert] = 'No es posible eliminar zonas especiales: veterinario, limpiadores, externo o intercambio'
         redirect_to :action=>"administracionzonas"
    else


       #Vacio: comprueba que la zona a eliminar no contiene animales en su interior
       @animales = Animal.find(:first, :conditions => ["zona_id = ?", @zona.id])
#    @cheniles = Chenil.find(:first, :conditions => ["zona_id = ?", @zona.id])

    
       if (!@animales.nil?)
   	 flash[:notice] = 'No ha sido posible eliminar la zona seleccionada, CONTIENE ANIMALES, pongase en contacto con el coordinador/veterinario de la zona o cree un coordinador/veterinario nuevo y mueva o elimine los animales que contiene'
         redirect_to :action=>"cheniles", :id=> @zona.id

       else
         respond_to do |format|
            flash[:notice] = 'Zona eliminada correctamente.'
            @zona.destroy
            format.html { redirect_to :action=>'administracionzonas' }
            format.json { head :no_content }
         end

       end

    end
  end



###################################
# Asignación ocupaciones a permisos
###################################

  private

        def authenticate
           deny_access unless signed_in?
        end

	def usuario_administrador
	   deny_destroy unless current_persona.ocupacion_id==7
	end

        def deny_destroy
    	   store_location
    	   redirect_to (zonas_path), :notice => "Ponte en contacto con el Administrador para crear/eliminar zonas."
  	end

	def usuario_coordinador
	   deny_edit unless current_persona.ocupacion_id==1
	end

        def deny_edit
    	   store_location
    	   redirect_to (zonas_path), :notice => "Tienes que tener permisos de Coordinador para editar esta zona."
  	end

  end
