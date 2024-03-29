class AddForeingKey < ActiveRecord::Migration[7.0]
  def change
    # Agrega la opción ON DELETE CASCADE a la clave foránea color_id
    remove_foreign_key :item_descriptions, :colors
    add_foreign_key :item_descriptions, :colors, column: :color_id, on_delete: :cascade

    # Agrega la opción ON DELETE CASCADE a la clave foránea size_id
    remove_foreign_key :item_descriptions, :sizes
    add_foreign_key :item_descriptions, :sizes, column: :size_id, on_delete: :cascade

    remove_column :item_descriptions, :category
  end
  
end
