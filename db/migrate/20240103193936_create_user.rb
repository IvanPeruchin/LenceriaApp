class CreateUser < ActiveRecord::Migration[7.0]
  create_table :users do |t|
    t.string :username
    t.string :password
    t.string :email
  end
end
