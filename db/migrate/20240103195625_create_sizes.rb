class CreateSizes < ActiveRecord::Migration[7.0]
  create_table :sizes do |t|
    t.string :number
    t.string :category
  end
end
