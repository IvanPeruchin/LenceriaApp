class AddColumnCategoryItem < ActiveRecord::Migration[7.0]
  def change
    add_column :item_descriptions, :category, :string
  end
end
