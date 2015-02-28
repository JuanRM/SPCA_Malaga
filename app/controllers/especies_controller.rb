class EspeciesController < ApplicationController


#####################################
  # Listado de especies existentes
  # new.animal ->
  # edit.animal -> 
  # -> new, edit, destroy
#####################################

  def index
    @especies = Especie.all
  end


#####################################
  # Crea especie nueva
  #  index ->
  #  -> index
#####################################

  def new
    @especie = Especie.new
  end


#####################################
  # Guarda especie nueva
  #   invoca función "new" para recoger datos
#####################################

  def create
    @especie = Especie.new(params[:especie])
    if @especie.save
       redirect_to (especies_path), :notice => "Especie creada correctamente."
    else
      render :action => 'new'
    end
  end


#####################################
  # Edita nombre especie existente
  # index ->
  # -> update
#####################################

  def edit
    @especie = Especie.find(params[:id])
  end


#####################################
  # Guarda cambios en el nombre de una especie
  # edit ->
  # -> index
#####################################

  def update
    @especie = Especie.find(params[:id])
    if @especie.update_attributes(params[:especie])
       redirect_to (especies_path), :notice => "Especie modificada correctamente."
    else
      render :action => 'edit'
    end
  end


#####################################
  # Elimina especie
  # index ->
  # -> index
#####################################

  def destroy
    @especie = Especie.find(params[:id])
    @especie.destroy
    redirect_to especies_url, :notice => "Especie eliminada correctamente."
  end

end
