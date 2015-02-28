class PersonasController < ApplicationController


###################################
# PERMISOS
###################################

before_filter :authenticate
before_filter :usuario_coordinador, :only => [:destroy]
before_filter :usuario_coorpropio, :only => [:edit]



#####################################
# Listado de personas existentes
# menu-> 
# -> "show" ficha
# -> "new"
#####################################

 def index

    @zonas = Zona.all
    @ocupacions = Ocupacion.all


    #permite filtrado por zona y ocupación
    @parametros=0

    if params[:zona]!=nil
       @zona = Zona.find(params[:zona])
       @parametros=1
    end

    if params[:ocupacion]!=nil
       @ocupacion = Ocupacion.find(params[:ocupacion])
       @parametros= @parametros+2
    end


    case @parametros
    when 0
         @personas = Persona.find(:all, :order => "zona_id asc, ocupacion_id, nombre asc")
    when 1
         @personas = Persona.find(:all, :conditions=>["zona_id = ?", @zona.id], :order => "ocupacion_id, nombre asc")	
    when 2
         @personas = Persona.find(:all, :conditions=>["ocupacion_id = ?", @ocupacion.id], :order => "zona_id, nombre asc")
    when 3
         @personas = Persona.find(:all, :conditions=>["zona_id = ? AND ocupacion_id = ?", @zona.id, @ocupacion.id], :order => "nombre asc")
    end


######################3??????????????????????????????????????????????????????????????
#    respond_to do |format|
#      format.html # index.html.erb
#      format.json { render json: @personas }
#    end
  end


################################

################################

# def administracionpersonal
#    @personas = Persona.all

#    respond_to do |format|
#      format.html # index.html.erb
#      format.json { render json: @personas }
#    end
#  end



#####################################
# Muestra la ficha de una persona
#   index->
#   -> editar
#####################################

 def show
    @sesionpersona = current_persona
    @persona = Persona.find(params[:id])
    @title = @persona.nombre
    @patata
 end


#####################################
# Crea una persona nueva
#   - administrador : todos las ocupaciones
#   - coord/vet: voluntarios y auxiliares en su zona
#   index->
#####################################

 def new
   @title = "Sign up"
   @persona = Persona.new
   @ocupacions = Ocupacion.all
   @zona = current_persona.zona.nombre
   @ocupacion = current_persona.ocupacion_id
   @zonas = Zona.all

 end



#####################################
# Guarda datos persona creada
#   invoca función "new" para recoger datos
#####################################


 def create
   @persona = Persona.new(params[:persona])

    if (current_persona.ocupacion_id == 1)
       @persona.zona_id=current_persona.zona_id
       @persona.ocupacion_id=2
    end
    if (current_persona.ocupacion_id == 3)
       @persona.zona_id=current_persona.zona_id
       @persona.ocupacion_id=5 
    end

    if @persona.save
	redirect_to @persona
    else
	@title = "Sign up"
	render 'new'
    end
 end



#####################################
# Edita información de una persona
#  - coord/vet/administrador (info privada)
#  - propio usuario (info publica)
#  show->
#####################################

 def edit
    @persona = Persona.find(params[:id])

 end



#####################################
# Guarda datos nuevos en una zona
#  edit->
#####################################

 def update
   @persona = Persona.find(params[:id])

    respond_to do |format|
      if @persona.update_attributes(params[:persona])
        format.html { redirect_to @persona, notice: 'Cambios guardados correctamente' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @persona.errors, status: :unprocessable_entity }
      end
    end

 end


#####################################
# Elimina persona del sistema
#   - administrador: todos los perfiles
#   - coord/vet: vol/aux en sus módulos
#   show->
#####################################

 def destroy
   @persona = Persona.find(params[:id])

   if @persona.ocupacion_id==7
   	 flash[:alert] = 'No se puede eliminar el perfil de administrador'
         redirect_to :action=>"index"
   else
     @persona.destroy

     respond_to do |format|
       format.html { redirect_to personas_url }
       format.json { head :no_content }
     end
   end

  end



###################################
# Asignación ocupaciones a permisos
###################################

private
  
	def usuario_coordinador
	   deny_destroy unless (current_persona.ocupacion_id==7 || (current_persona.ocupacion_id==1 || current_persona.ocupacion_id== 3))
	end

	def usuario_coorpropio
	   @persona = Persona.find(params[:id])
	   deny_destroy unless current_persona.id==@persona.id || (current_persona.ocupacion_id==7 || (current_persona.ocupacion_id==1 || current_persona.ocupacion_id== 3))
	end

        def deny_destroy
    	   store_location
    	   redirect_to (personas_path), :notice => "Solo el Administrador puede dar de baja o editar los perfiles de todos los usuarios, los Coordinadores y Veterinarios solo puedel dar de baja o editar los perfiles de los voluntarios y auxiliares de su zona."
#"Necesitas permisos de coordinador para dar de baja una persona y para editar un perfil."
  	end

end
