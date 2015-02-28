class AnimalsController < ApplicationController


#before_filter :signed_in?, :except => [:index, :show]
#407 (personal) before_filter :coorect_user, :only => [:edit, :update]
before_filter :authenticate
before_filter :usuario_c_v, :only => [:destroy, :new, :edit, :relaciones]
# ----------------- relaciones ??????????


  Coordinador=1
  Voluntario=2
  Veterinario=3
  Limpiador=4



#####################################
  # Listado de animales existentes
  #   menu->
  #   ordenado->
  #   -> ordenado 
  #   -> "show" ficha
  #   -> "new"
#####################################

  def index


   #recoge paramatro zona
   if params[:zona]!=nil
     if params[:zona]=="todas"
         $zonaurl=nil
     else
         @zonaurl = params[:zona]
         $zonaurl = @zonaurl
     end
   end
   
   if !$zonaurl.nil?
     @zona = Zona.find($zonaurl)
   end
#------------------------------------------

   #si no hay parametros de busqueda
   if params[:search].nil? && params[:especie]==nil && params[:sexo]==nil
      $numero=1
   end
   $numero

   #guarda parametro search
   if !params[:search].nil?
      @searchurl= params[:search]
      @busquedaurl = "#{@searchurl}"
   end

   #guarda parametro nombre
   if !params[:nombre].nil?
      @nombreurl= params[:nombre]
      @busquedaurl= @nombreurl
   end


   case $numero
    when 1 , nil
     if $zonaurl.nil? #|| @busquedaurl.nil? #comprobar condiciones: no $zona ó no $busqueda
  	@animals = Animal.search1(@busquedaurl)
     else
        if @busquedaurl.nil?
	    @animals = Animal.find(:all, :conditions => ['zona_id = ?', $zonaurl])
        else
            @animals = Animal.find(:all, :conditions => ['nombre LIKE ? AND zona_id = ?', '%'+@busquedaurl+'%', $zonaurl])
        end
     end
     $numero=1
     @busqueda = "nombre"


    when 4
     if !params[:raza].nil?
       @nombreurl= params[:raza]
       @busquedaurl= @nombreurl
     end

     if $zonaurl.nil?
        @animals = Animal.find(:all, :conditions => ['raza LIKE ?', '%'+@busquedaurl+'%'], :order => "raza asc, nombre asc")
     else
        @animals = Animal.find(:all, :conditions => ['raza LIKE ? AND zona_id = ?', '%'+@busquedaurl+'%', $zonaurl], :order => "raza asc, nombre asc")
     end       
        $numero = 4
       @busqueda = "raza"


   when 6
     @busquedaurl=params[:especie]
     if $zonaurl.nil?
  	@animals = Animal.search6(params[:especie])
     else
        @animals = Animal.find(:all, :conditions => ["especie_id = ? AND zona_id = ?", @busquedaurl, $zonaurl], :order => "nombre asc")
     end
        $numero=6
        @busqueda = "especie"


   when 7
     @busquedaurl=params[:sexo]
     if $zonaurl.nil?
  	@animals = Animal.search7(params[:sexo])
     else
        @animals = Animal.find(:all, :conditions => ["sexo LIKE ? AND zona_id = ?", @busquedaurl, $zonaurl], :order => "nombre asc")
     end
     $numero=7
     @busqueda = "sexo"

  end

   @chenils = Chenil.all
   @zonas = Zona.all


########################################################3
# PAGINACIÓN animales: todos/busquedaxzonas

    if @busquedaurl.nil? || @busquedaurl.empty?

      # Número de animaless por página
      @animales_por_pagina = 20 
      # Número de paginas totales
      @pagina_count = (@animals.count/@animales_por_pagina)+1

      # actualiza parametro pagina
      @pagina = params[:page_id].to_i
      @pagina = 1 unless @pagina > 0
      @pagina = @pagina_count unless @pagina < @pagina_count
      # Primer registro que debemos sacar según la pagina
      @comienzo = (@pagina - 1) * @animales_por_pagina

      # Extrae de la busqueda realizada los animales pertenecientes a una página 
      @animales_en_busqueda = @animals.count
      if @animales_en_busqueda > @animales_por_pagina
         @masanimales = 1
      end
      @animals = @animals.slice(@comienzo, @animales_por_pagina)
      @count4 = @animals.count

    end

      @count4 = @animals.count
#############################################################


	

   respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @animals }
   end
  end


#####################################
  # Listado de animales existentes
  #  index->
  #  -> index
  #  -> "show" ficha
  #  -> "new"
#####################################

  def ordenado

   if params[:busqueda]!=nil
       @busqueda = params[:busqueda]
   else
       @busqueda = "Nombre"
   end  


   #recoge parametro "zona"
   if params[:zona]!=nil
     if params[:zona]=="todas"
         $zonaurl=nil
     else
         @zonaurl = params[:zona]
         $zonaurl = @zonaurl
     end
   end

   if !$zonaurl.nil?
     @zona = Zona.find($zonaurl)
   end


  
   #Recoge parametro "busqueda"
   case params[:busqueda]
    when "Nombre"
     if $zonaurl.nil?
  	@animals = Animal.search1(params[:search])
     else
        @animals = Animal.find(:all, :conditions => ["zona_id = ?", $zonaurl], :order => "nombre asc")
     end
     $numero = 1  
#     $zonaurl = @zonaurl

    when "F.entrada"       
     if $zonaurl.nil?
       @animals = Animal.find(:all, :order => "fecha_entrada DESC, nombre asc")
     else
       @animals = Animal.find(:all, :conditions => ["zona_id = ?", $zonaurl], :order => "fecha_entrada DESC, nombre asc")
     end
     $numero=2
#     $zonaurl = @zonaurl

    when "F.modificacion"
     if $zonaurl.nil?
       @animals = Animal.find(:all, :order => "updated_at DESC, nombre asc")
     else
       @animals = Animal.find(:all, :conditions => ["zona_id = ?", $zonaurl], :order => "updated_at DESC, nombre asc")
     end
       $numero=3

    when "Raza"
     if $zonaurl.nil?
  	@animals = Animal.search4(params[:search])
     else
        @animals = Animal.find(:all, :conditions => ["zona_id = ?", $zonaurl], :order => "raza asc, nombre asc")
     end
#        $zonaurl = @zonaurl
        $numero = 4

    when "Especie"
     if $zonaurl.nil?
  	@animals = Animal.search6(params[:search])
     else
        @animals = Animal.find(:all, :conditions => ["zona_id = ?", $zonaurl], :order => "especie_id asc, nombre asc")
     end
     $numero = 6     

    when "Sexo"
     if $zonaurl.nil?
  	@animals = Animal.search7(params[:search])
     else
        @animals = Animal.find(:all, :conditions => ["zona_id = ?", $zonaurl], :order => "sexo asc, nombre asc")
     end
        $numero = 7
   end


    @chenils = Chenil.all
    @zonas = Zona.all

########################################################3
# PAGINACIÓN

    # Número de animaless por página
    @animales_por_pagina = 20 
    @pagina = params[:page_id].to_i
    @pagina = 1 unless @pagina > 0
    # Primer registro que debemos sacar según la pagina
    @comienzo = (@pagina - 1) * @animales_por_pagina
    # Número de paginas totales
    @pagina_count = (Animal.all.count/@animales_por_pagina)+1

    # Controla si hay mas animales que los que caben en una pagina 
    @animales_en_busqueda = @animals.count
    if @animales_en_busqueda > @animales_por_pagina
       @masanimales = 1
    end
    # Extrae de la busqueda realizada los animales pertenecientes a una página 
    @animals = @animals.slice(@comienzo, @animales_por_pagina)
 

#############################################################

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @animals }
    end

  end



#####################################
  # Muestra la ficha de un animal
  #   index->
  #   ordenado->
  #   -> editar, mover, eliminar, relaciones
  #   -> añadir nota
#####################################

  def show
    @animal = Animal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @animal }
    end
  end



#####################################
  # Añade una nota a un animal 
  #  show->
#####################################

  def add_nota
    @animal = Animal.find(params[:id])
  end



#####################################
  # Mueve un animal (dentro de su zona) 
  #  (de mi zona a zona de libremovimiento) 
  #  show->
  #  -> moverzona
#####################################

  def mover

    @animal = Animal.find(params[:id2])
    @zona = Zona.find(params[:id1])


    #Controlar animal.zona = user.zona || animal.zona <- libremoviento
    # permisos mover????????????????????????????????????????????????????????????????????????????????
    if ((@animal.zona_id != current_persona.zona_id && @animal.zona.libremovimiento!=1) || (@zona.id != current_persona.zona_id && @zona.libremovimiento!=1))
	flash[:notice] = 'Acceso no permitido, animal o zona restringida para su perfil.'
	redirect_to :action=>"show", :id=>@animal.id

    else
	@chenil = @animal.chenil_id
	@chenils = Chenil.find(:all, :conditions => ["zona_id = ?", @zona.id], :order => "numero ASC")
        #?????????? porque no por zona???
	@animals = Animal.where("chenil_id in (?)", @chenils) 
	@relacion_animals = RelacionAnimal.find(:all, :conditions => ["animal1_id = ? OR animal2_id = ?", @animal.id, @animal.id])	

	respond_to do |format|
		format.html # index.html.erb
		format.json { render json: @animals }
	end
    end

  end



#####################################
  # Elige zona de libremoviento a la que mover animal 
  #  mover->
  #  ->mover
#####################################

  def zona_mover
    @animal = Animal.find(params[:id])
    @zonas = Zona.find(:all, :conditions => ["libremovimiento = ?", 1])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @animal }
    end
  end



#####################################
#??????????????????????????????????????????????????????????????
# no es necesaria, pero si la dejo: visual
# redirect animal, flash animal movido correctamente
#####################################
#####################################
  # Guarda los cambios en el movimiento del animal 
  #  mover->
  #  ->show ()redirect-------------------------------
#####################################

  def moverfin
    @animal = Animal.find(params[:id1])
    @chenil = Chenil.find(params[:id2])    
  end



#####################################
  # Mueve animal de zona libremoviento a mi zona
  #  show->
  #  -> moverfin
#####################################

  def moveraMiZona
    @animal = Animal.find(params[:id])

    @aux

    @chenil = @animal.chenil_id
    @zona = current_persona.zona

    @chenils = Chenil.find(:all, :conditions => ["zona_id = ?", @zona.id])
    @animals = Animal.where("chenil_id in (?)", @chenils)
 
    @relacion_animals = RelacionAnimal.find(:all, :conditions => ["animal1_id = ? OR animal2_id = ?", @animal.id, @animal.id])	

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @animals }
    end
  end



#####################################
  # Crea relación nueva
  #   ->relacionesXanimal
#####################################

  def relaciones

    @animal = Animal.find(params[:id])


    @animals = Animal.find(:all, :conditions => ["zona_id = ? AND id != ?", @animal.zona_id, @animal.id], :order => "nombre ASC")

    @chenil = @animal.chenil_id
    @zona = @animal.chenil.zona_id
    @relacion_animal = RelacionAnimal.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @animals }
    end

  end




#####################################
  # Muestra las relaciones existentes entre un animal y sus compañeros
  #  show->
  #  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!COMO EN MOVER X CHENILES
#####################################
 
  def relacionesXanimal

    @animal = Animal.find(params[:id])
    @zona = @animal.zona_id

    @relacionplus = RelacionAnimal.find(:all, :conditions => ["animal1_id = ? OR animal2_id = ?", @animal.id, @animal.id])


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @animals }
    end
  end



#####################################
  # Crea animal nuevo
  #  index ->
  #  -> show
#####################################

  def new

    @animal = Animal.new
 
    @zona = current_persona.zona

    @chenils = Chenil.find(:all, :conditions => ["zona_id = ? AND caplibre > ?", @zona.id, 0], :order => "numero ASC")

    @especies = Especie.all

    @aux = @animal.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @animal }
    end

  end



#####################################
  # Guarda animal nuevo
  #   invoca función "new" para recoger datos
#####################################

  def create
    @animal = Animal.new(params[:animal])
    @animal.zona_id=@animal.chenil.zona_id
    @animal.fecha_entrada=Date.today

    respond_to do |format|
      if @animal.save
        format.html { redirect_to @animal, notice: 'Animal nuevo creado correctamente.' }
        format.json { render json: @animal, status: :created, location: @animal }

        @animal.chenil.caplibre=@animal.chenil.caplibre-1
        @animal.chenil.save
      else
        @zona = current_persona.zona
        @chenils = Chenil.find(:all, :conditions => ["zona_id = ? AND caplibre > ?", @zona.id, 0], :order => "numero ASC")
        @especies = Especie.all
        format.html { render action: "new", notice: 'No se puede crear animal nuevo.' }
        format.json { render json: @animal.errors, status: :unprocessable_entity }
      end
    end
  end



#####################################
  # Edita información de un animal
  #  show->
  #  -> update
#####################################

  def edit

    @animal = Animal.find(params[:id])
    @chenils = Chenil.all
    @especies = Especie.all
    
  end



#####################################
  # Guarda datos nuevos en un animal
  #  edit->
  #  add_nota->
  #  -> show
#####################################

  def update

    @animal = Animal.find(params[:id])
    @nombre = current_persona.nombre
    @date= Date.today.to_s

    respond_to do |format|
      if @animal.update_attributes(params[:animal])
        format.html { redirect_to @animal, notice: 'Animal modificado correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @animal.errors, status: :unprocessable_entity }
      end

      if !@animal.nuevoNA.nil? && !@animal.nuevoNA.empty?
	if @animal.notas.nil? || @animal.notas.empty?  
		@animal.notas= @date+" / "+@nombre+":  "+@animal.nuevoNA
		@animal.nuevoNA=""
		@animal.save  		  	
	else
        	@animal.notas= @animal.notas+"\n"+@date+" / "+@nombre+":  "+@animal.nuevoNA
		@animal.nuevoNA=""
		@animal.save
	end
      end

    end
  end



#####################################
  # Elimina animal del sistema
  #   show->
#####################################

  def destroy
    @animal = Animal.find(params[:id])
    @chenilaux = @animal.chenil
    @chenilaux.caplibre=@chenilaux.caplibre+1
    @animal.destroy
    @chenilaux.save
    

    respond_to do |format|
      format.html { redirect_to animals_url, notice: 'Animal borrado correctamente.' }
      format.json { head :no_content }
    end
  end



###################################
  # Asignación ocupaciones a permisos
###################################

private

	def usuario_c_v
	   deny_destroy unless (current_persona.ocupacion_id==1 || current_persona.ocupacion_id==3)
	end

        def deny_destroy
    	   store_location
    	   redirect_to (animals_path), :notice => "Necesitas permisos de coordinador/veterinario para dar de alta/baja/editar un animal."
  	end

        before_filter :usuario_c_v, :only => [:destroy, :new, :edit, :mover, :relaciones]

end
