class CreateColors < ActiveRecord::Migration[7.0]
  create_table :colors do |t|
    t.string :name
  end
end