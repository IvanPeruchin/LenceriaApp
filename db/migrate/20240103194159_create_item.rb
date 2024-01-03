class CreateItem < ActiveRecord::Migration[7.0]
  create_table :items do |t|
    t.string :name
    t.string :price
    t.string :category
    t.string :image #url de la imagen
    t.boolean :in_stock
  end
end
