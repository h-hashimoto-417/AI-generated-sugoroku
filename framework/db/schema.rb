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

ActiveRecord::Schema[7.1].define(version: 2026_05_28_012620) do
  create_table "games", force: :cascade do |t|
    t.integer "map_id", null: false
    t.integer "num_of_players"
    t.integer "current_turn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["map_id"], name: "index_games_on_map_id"
  end

  create_table "maps", force: :cascade do |t|
    t.string "map_name"
    t.integer "num_of_squares"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.integer "game_id", null: false
    t.string "pname"
    t.integer "user_id", null: false
    t.integer "curr_position"
    t.string "ucolor"
    t.string "string"
    t.boolean "status"
    t.integer "turn_skip"
    t.integer "turn_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_players_on_game_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "squares", force: :cascade do |t|
    t.integer "map_id", null: false
    t.integer "position"
    t.string "square_type"
    t.string "square_text"
    t.string "effect"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["map_id"], name: "index_squares_on_map_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uname"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "games", "maps"
  add_foreign_key "players", "games"
  add_foreign_key "players", "users"
  add_foreign_key "squares", "maps"
end
