# frozen_string_literal: true
require 'sinatra/base'
require 'bcrypt'
require 'mail'
require_relative '../methods'

# Esta es la clase maneja la autenticacion de usuarios,
# incluyendo el inicio de sesion, registro, validaciln de correo electronico
# y gestion de sesiones de usuario.
class StartController < Sinatra::Application
  hashed_password = BCrypt::Password.create('12345678')

  # Ruta para mostrar la pagina de inicio de sesion.
  get '/login' do
    erb :login
  end

  # Maneja la solicitud POST de inicio de sesion.
  post '/login' do
    if params['username'] == 'Silbia' && BCrypt::Password.new(hashed_password) == params['password']
      session[:admin] = true
      redirect '/admin'
    else 
      redirect '/login'
    end
  end

   # Ruta para mostrar la tienda.
   get '/categories' do 
    session[:item] = params[:category]
    @item_selected = session[:item]
    @item = Item.where(category: @item_selected)
    erb :categories
  end

  get '/information' do
    erb :information
  end

  get '/item_information/:id' do
    @item_selected = session[:item]
    @item = Item.find(params[:id])
    # SOLO HACER ESTO PARA PROBAR Y ESTILAR, LUEGO CAMBIAR
    @sizes = Size.where(category: @item_selected)
    @colors = Color.all
    erb :item_information
  end

end
