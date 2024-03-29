class DeleteColumnSizes < ActiveRecord::Migration[7.0]
  def change
    remove_column :sizes, :category
  end
end
