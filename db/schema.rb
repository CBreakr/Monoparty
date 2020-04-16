# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_16_160937) do

  create_table "card_games", force: :cascade do |t|
    t.integer "card_id"
    t.integer "game_id"
    t.integer "deck_order"
    t.boolean "is_used"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cards", force: :cascade do |t|
    t.string "card_name"
    t.string "card_text"
    t.string "card_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "method_name"
    t.integer "default_quantity"
  end

  create_table "game_spaces", force: :cascade do |t|
    t.integer "space_id"
    t.integer "game_id"
    t.integer "placement_order"
    t.integer "rent_level", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "position"
  end

  create_table "games", force: :cascade do |t|
    t.string "game_name"
    t.boolean "is_started"
    t.boolean "is_finished"
    t.integer "turn_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "player_games", force: :cascade do |t|
    t.integer "game_id"
    t.integer "player_id"
    t.string "color"
    t.integer "turn_order"
    t.boolean "is_current_turn"
    t.integer "money"
    t.boolean "has_conceded"
    t.integer "in_jail_rolls_remaining", default: 0
    t.boolean "has_get_out_of_jail_card"
    t.integer "current_position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "turn_phase"
    t.boolean "is_winner"
  end

  create_table "players", force: :cascade do |t|
    t.string "player_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "properties", force: :cascade do |t|
    t.integer "player_id"
    t.integer "game_id"
    t.integer "space_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "spaces", force: :cascade do |t|
    t.string "space_name"
    t.integer "space_cost"
    t.integer "rent_level1"
    t.string "group"
    t.string "space_type"
    t.integer "default_position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "method_name"
  end

end
