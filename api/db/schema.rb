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

ActiveRecord::Schema[7.1].define(version: 2024_02_20_153630) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "kanban_cards", force: :cascade do |t|
    t.bigint "kanban_column_id"
    t.string "title"
    t.string "description"
    t.integer "position"
    t.date "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kanban_column_id"], name: "index_kanban_cards_on_kanban_column_id"
  end

  create_table "kanban_cards_tags", id: false, force: :cascade do |t|
    t.bigint "kanban_card_id"
    t.bigint "tag_id"
    t.index ["kanban_card_id"], name: "index_kanban_cards_tags_on_kanban_card_id"
    t.index ["tag_id"], name: "index_kanban_cards_tags_on_tag_id"
  end

  create_table "kanban_columns", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_kanban_columns_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "label"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "kanban_cards", "kanban_columns"
  add_foreign_key "kanban_columns", "users"
  add_foreign_key "tags", "users"
end
