# frozen_string_literal: true

require 'bcrypt'
require 'mail'
require_relative '../methods'

# Esta es la clase maneja la autenticacion de usuarios,
# incluyendo el inicio de sesion, registro, validaciln de correo electronico
# y gestion de sesiones de usuario.
class StartController < Sinatra::Application
  # Ruta para mostrar la pagina de inicio de sesion.
  get '/login' do
    erb :login
  end

  # Maneja la solicitud POST de inicio de sesion.
  post '/login' do
    @user = User.current_user(:username, params[:username])
    check_user(@user)
  end


  # Ruta para cerrar sesion.
  get '/logout' do
    session.clear
    redirect '/'
  end

  # Ruta para mostrar la pagina de validacion de correo electronico.
  get '/validate' do
    erb :validate
  end

  # Maneja la solicitud POST de validacion de correo electronico.
  post '/validate' do
    if session[:code] == params[:codigo]
      user = User.current_user(:id, session[:user_id])
      user.update_column(:valid_email, true)
    end
    # ------------------ ver de ingresar codigo hasta 3 veces, sino reenviar codigo
    redirect '/menu'
  end

  get '/categories' do 
    @item_selected = params[:category]
    @item = Item.where(category: @item_selected)
    erb :categories
  end

  get '/information' do
    erb :information
  end

  #------------------------------------------------------ METODOS --------------------------------------------------------------#

  # Metodo para iniciar sesion.
  def check_user(user)
    if user&.compare_password(user.password, params[:password])
      user.login_user(session)
      redirect '/menu'
    elsif user
      @password_error = '*contraseña incorrecta'
      erb :login
    else
      @password_error = '*datos ingresados no pertenecen a ninguna cuenta'
      erb :login
    end
  end

  # Metodo para registrar un usuario.
  def create_user
    redirect '/register' unless passwords_match
    user_attributes = { username: params[:username], password: hash_password(params[:password]),
                        email: params[:email]}
    @user = User.create(user_attributes)
    if @user.save
      initialize_user_settings(@user)
      redirect '/validate'
    else
      redirect '/register'
    end
  end

  # Verifica si las contrasenias coinciden
  def passwords_match
    params[:password] == params[:passwordTwo]
  end

  # Inicializa las configuraciones del usuario
  def initialize_user_settings(user)
    session[:user_id] = user.id
    send_verificated_email(user.email, session[:code])
  end
end
