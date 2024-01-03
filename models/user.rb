# frozen_string_literal: true

# Modelo para representar un usuario en el sistema
class User < ActiveRecord::Base
  has_many :catalogs

  validates :username, presence: true, length: { minimum: 3, message: 'username must be at least 3 characters' }
  validates :password, presence: true, length: { minimum: 6, message: 'password must be at least 6 characters' }
  validates :email, presence: true,
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: 'invalid email format' }

  def login_user(session)
    session[:user_id] = id
  end

  # desencripta password y la compara con la ingresada
  def compare_password(hash_pass, password)
    BCrypt::Password.new(hash_pass) == password
  end


  # Obtiene el usuario actual en la sesion.
  def self.current_user(field, value)
    return User.find_by(field => value) if value && field
  end

end
