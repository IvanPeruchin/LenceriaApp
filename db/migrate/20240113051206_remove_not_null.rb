class RemoveNotNull < ActiveRecord::Migration[7.0]
  def change
    change_column :item_descriptions, :color_id, :integer, null: true
    change_column :item_descriptions, :size_id, :integer, null: true
  end
end
