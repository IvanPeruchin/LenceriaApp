# frozen_string_literal: true

require 'sinatra'
require 'sinatra/base'
require 'bundler/setup'
require 'logger'
require 'sinatra/activerecord'
require 'sinatra/cookies'
require 'dotenv/load'
require 'sinatra/reloader' if Sinatra::Base.environment == :development

require './controllers/start_controller.rb'
require './controllers/admin_controller'

require_relative 'models/item'
require_relative 'models/item_description'
require_relative 'models/color'
require_relative 'models/size'


# Clase principal para definir la aplicación de Sinatra
class App < Sinatra::Application
  Dotenv.load

  
  use StartController
  use AdminController
  
  enable :sessions
  # Configuración de la clave secreta de sesión
  set :root, File.dirname(__FILE__)
  set :session_secret, ENV['SESSION_SECRET']
  set :public_folder, File.dirname(__FILE__) + '/public'
  
  def initialize(_app = nil)
    super()
  end

  configure :production, :development do
    enable :logging

    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG if development?
    set :logger, logger
  end

  configure :development do
    register Sinatra::Reloader
    after_reload do
      puts 'Reloaded...'
      logger.info 'Reloaded!!!'
    end
  end

  get '/' do
    session[:admin] = false
    erb :start
  end
end
