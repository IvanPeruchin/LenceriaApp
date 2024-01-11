# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_01_10_155539) do
  create_table "colors", force: :cascade do |t|
    t.string "name"
  end

  create_table "item_descriptions", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "color_id", null: false
    t.integer "size_id", null: false
    t.string "category"
    t.index ["color_id"], name: "index_item_descriptions_on_color_id"
    t.index ["item_id"], name: "index_item_descriptions_on_item_id"
    t.index ["size_id"], name: "index_item_descriptions_on_size_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.string "category"
    t.string "image"
    t.boolean "in_stock"
  end

  create_table "sizes", force: :cascade do |t|
    t.string "number"
    t.string "category"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "email"
    t.boolean "valid_email", default: false
  end

  add_foreign_key "item_descriptions", "colors"
  add_foreign_key "item_descriptions", "items"
  add_foreign_key "item_descriptions", "sizes"
end
