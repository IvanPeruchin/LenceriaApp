class CreateItemDescriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :item_descriptions do |t|
      t.references :item, null: false, foreign_key: true
      t.references :color, null: false, foreign_key:true
      t.references :size, null: false, foreign_key: true
    end
  end
end
