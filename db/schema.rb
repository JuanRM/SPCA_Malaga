# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20141130170820) do

  create_table "animals", :force => true do |t|
    t.text     "nuevoNA"
    t.text     "notas"
    t.string   "nombre"
    t.string   "raza"
    t.string   "sexo"
    t.date     "fecha_entrada"
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "foto_file_name"
    t.string   "foto_content_type"
    t.integer  "foto_file_size"
    t.datetime "foto_updated_at"
    t.integer  "chenil_id"
    t.integer  "especie_id"
    t.integer  "zona_id"
    t.text     "veterinario"
  end

  create_table "chenils", :force => true do |t|
    t.integer  "ocupado"
    t.text     "Informacion"
    t.text     "nuevoNC"
    t.integer  "zona_id"
    t.integer  "capacidad"
    t.integer  "caplibre"
    t.text     "notas"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "numero"
  end

  create_table "diarios", :force => true do |t|
    t.text     "tareasdia"
    t.integer  "unificado"
    t.text     "turnost"
    t.text     "turnosm"
    t.text     "informet"
    t.integer  "zona_id"
    t.date     "fecha"
    t.text     "tareasave"
    t.text     "informe"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "nuevo"
    t.text     "nuevoI"
  end

  create_table "especies", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "horarios", :force => true do |t|
    t.decimal  "ocupacion_id"
    t.integer  "persona_id"
    t.integer  "zona_id"
    t.date     "fecha"
    t.integer  "tarde"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ocupacions", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "personas", :force => true do |t|
    t.integer  "zona_id"
    t.integer  "ocupacion_id"
    t.text     "privado"
    t.text     "publico"
    t.string   "nombre"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.integer  "perfil_id"
  end

  create_table "relacion_animals", :force => true do |t|
    t.integer  "animal1_id"
    t.integer  "animal2_id"
    t.string   "relacion",   :limit => nil
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipos_rels", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "zonas", :force => true do |t|
    t.integer  "libremovimiento"
    t.text     "tareas"
    t.text     "Informes"
    t.date     "fechaunif"
    t.text     "nuevoNZ"
    t.text     "text"
    t.text     "notas"
    t.string   "nombre",          :limit => 25
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
