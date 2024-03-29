# frozen_string_literal: true

# encripta la password
def hash_password(pass)
  salt = BCrypt::Engine.generate_salt
  hashed_password = BCrypt::Engine.hash_secret(pass, salt)
  hashed_password
end

