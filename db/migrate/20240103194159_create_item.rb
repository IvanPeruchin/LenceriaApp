class CreateItem < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.column :price, :float
      t.string :category
      t.string :image # URL de la imagen
      t.boolean :in_stock
    end
  end
end
