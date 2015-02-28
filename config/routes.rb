Pruebaanimales3::Application.routes.draw do



resources :zonas
################
  match 'add_nota_zonas', :to => 'zonas#add_nota#id'
  match 'editar_tareas', :to => 'zonas#editar_tareas#id'
  #repasar permisos
  match 'administracionzonas', :to => 'zonas#administracionzonas'



resources :chenils
##################
  match 'cheniles', :to => 'zonas#cheniles#id'  
  match 'add_nota_chenil', :to => 'chenils#add_nota#id'



resources :animals
##################
  match 'ordenado', :to => 'animals#ordenado#id'
  match 'add_nota_animales', :to => 'animals#add_nota#id'
  match 'animals/nuevo', :to => 'animals#new' 
  match 'mover', :to => 'animals#mover#id1#id2'
  #visual##
  match 'moverfin', :to => 'animals#moverfin#id1#id2'
  match 'zona_mover', :to => 'animals#zona_mover#id'
  match 'moveraMiZona', :to => 'animals#moveraMiZona#id'
  #########
#  get 'animales/pagina/:page_id', :to=> 'animals#index#id#id'
  match 'animals', :to=> 'animals#index#page_id#zona'
  match 'ordenado', :to=> 'animals#ordenado#page_id#id#id'
  #get 'ordenado/pagina/:page_id', :to=> 'animals#ordenado#id#id#id'
#  get 'users/page/:page_id', to: 'users#index', as: 'users_pagination'

    resources :especies
    ###################

    resources :relacion_animals
    ###########################
	match 'relaciones/:id', :to => 'animals#relaciones'
	match 'relacionesXanimal/:id', :to => 'animals#relacionesXanimal'



resources :personas
###################
  get "personas/new"

    resources :ocupacions
    #####################

    resources :sessions, :only => [:new, :create, :destroy]
    ####################
	match '/signin', :to => 'sessions#new'
	match '/signout', :to => 'sessions#destroy'
	get "sessions/new"



resources :diarios
##################
  match 'add_informe', :to => 'diarios#add_informe#id'
  match 'diarios/show', :to => 'diarios#show#fecha#zona'
  match 'diarios_new', :to => 'diarios#new#fecha#zona'
  match 'edittareadia', :to => 'diarios#edittareadia#id'



resources :horarios
###################
  match 'vistahorario', :to => 'horarios#vistahorario'
  match 'asignar_turno', :to => 'horarios#asignar_turno#date#tarde#zona'
  match 'crearturnodatos', :to => 'horarios#crearturnodatos#fecha#zona#tarde#persona'
  match 'horarios', :to => 'horarios#index#zona'
  match 'horarios', :to => 'horarios#index#zona#month'
  match 'horarios_informeSemana', :to => 'horarios#informeSemana#fecha#zona'
  match 'horarios_informeAnteriores', :to =>'horarios#informeAnteriores'
  match 'horarios_unificacion', :to => 'horarios#unificacion'
  match 'horarios_unificacionturnos', :to =>'horarios#unificacionturnos'
  match 'editar_informeAnterior', :to => 'horarios#editarinformeAnterior#id'




####################
match '/home', :to => 'pages#home'
root :to => 'sessions#new'
####################



end
