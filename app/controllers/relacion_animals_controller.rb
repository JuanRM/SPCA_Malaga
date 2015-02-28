class RelacionAnimalsController < ApplicationController
before_filter :authenticate
before_filter :usuario_c_v, :only => [:destroy, :edit, :new]



#####################################
 # Muestra relación existente entre dos animales
 #   edit->
 #   -> edit
 #   -> eliminar
#####################################

  def show

    @relacion_animal = RelacionAnimal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @relacion_animal }
    end

  end



#####################################
 # Edita el tipo de una animal
 #  ANIMAL.relacionesxanimal->
 #  show->
 #  -> update
#####################################

  def edit

    @relacion_animal = RelacionAnimal.find(params[:id])
    @tiposRel = TiposRel.all

  end


#####################################
 # Crear relación nueva entre dos animales
 #  ANIMAL.relaciones ->
 #  -> show
#####################################

  def create
    @relacion_animal = RelacionAnimal.new(params[:relacion_animal])

    @animal1=@relacion_animal.animal1_id
    @animal2=@relacion_animal.animal2.id    
	
    @duplicado=RelacionAnimal.find(:all, :conditions => ["(animal1_id = ? and animal2_id =?) or (animal1_id = ? and animal2_id = ?)", @animal1, @animal2, @animal2, @animal1])

    respond_to do |format|
      # controla no exista ya la ralación 
      if @duplicado.empty?

        if @relacion_animal.save
          format.html { redirect_to @relacion_animal, notice: 'Relacion animal creada correctamente.' }
          format.json { render json: @relacion_animal, status: :created, location: @relacion_animal }
        else
          format.html { render action: "new" }
          format.json { render json: @relacion_animal.errors, status: :unprocessable_entity }
        end

      else 
        format.html { redirect_to @duplicado, alert: 'Existe una relacion anterior entre estos dos animales .' }
end
      end

  end

 


#####################################
 # Guarda cambios en una relación
 #  edit ->
 #  -> show
#####################################

  def update

    @relacion_animal = RelacionAnimal.find(params[:id])

    respond_to do |format|
      if @relacion_animal.update_attributes(params[:relacion_animal])
        format.html { redirect_to @relacion_animal, notice: 'Relacion animal fue modificada con exito.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @relacion_animal.errors, status: :unprocessable_entity }
      end
    end

  end



#####################################
 # Elimina una relación del sistema
 #  ANIMAL.relacionesxanimal ->
 #  show ->
 #  -> ANIMAL.index
#####################################

  def destroy

    @relacion_animal = RelacionAnimal.find(params[:id])
    @relacion_animal.destroy

    respond_to do |format|
        format.html { redirect_to animals_url, notice: 'Relacion animal borrada correctamente.' }
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
    	   redirect_to (animals_path), :notice => "Necesita permisos de coordinador/veterinario para dar de baja/alta/editar una relacion entre animales."
  	end

end


