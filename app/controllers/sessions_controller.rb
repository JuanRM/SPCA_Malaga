class SessionsController < ApplicationController


#####################################
# Recoge datos para crear una sesion
#   inicio->
#####################################

  def new
	@title = "Sign in"
  end



#####################################
# Crea una sesión para un usuario registrado
#   new->
#####################################

  def create
	persona = Persona.authenticate(params[:session][:email],
	params[:session][:password])
    if persona.nil?
	flash.now[:error] = "Invalida combinacion de email/password."
	@title = "Inicio"
	render 'new'
    else
	sign_in persona

	if persona.ocupacion_id==7
           redirect_to ('/administracionzonas')
        else  
           redirect_to (zonas_path)
	end

    end

  end



#####################################
# Destruye sesión
#   menu->
#####################################

  def destroy
	sign_out
	redirect_to root_path
  end


end
