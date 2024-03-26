# frozen_string_literal: true
require 'sinatra/base'
require 'bcrypt'
require 'dotenv/load'
require_relative '../methods'

# Esta es la clase maneja la autenticacion de usuarios,
# incluyendo el inicio de sesion, registro, validaciln de correo electronico
# y gestion de sesiones de usuario.
class StartController < Sinatra::Application
  Dotenv.load

  hashed_password = BCrypt::Password.create(ENV['DB_PASSWORD'])

  # Ruta para mostrar la pagina de inicio de sesion.
  get '/login' do
    erb :login
  end

  # Maneja la solicitud POST de inicio de sesion.
  post '/login' do
    puts "El user es: #{ENV['DB_USERNAME']} y la contra es #{ENV['DB_PASSWORD']}"
    if params['username'] == ENV['DB_USERNAME'] && BCrypt::Password.new(hashed_password) == params['password']
      session[:admin] = true
      redirect '/admin'
    else 
      puts "El user es: #{ENV['DB_USERNAME']} y la contra es #{ENV['DB_PASSWORD']}"
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

    item_descriptions = ItemDescription.where(item_id: @item.id)
    colors_id = item_descriptions.map { |item_desc| item_desc&.color_id}.compact
    sizes_id = item_descriptions.map { |item_desc| item_desc&.size_id }.compact
    @colors = colors_id.map { |item_color| Color.find_by(id: item_color)}
    @sizes = sizes_id.map { |item_sizes| Size.find_by(id: item_sizes)}
    
    erb :item_information
  end

end
