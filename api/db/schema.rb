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

ActiveRecord::Schema.define(version: 2021_08_07_142311) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "match_players", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "match_team_id"
    t.integer "start_rating"
    t.integer "end_rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["match_team_id"], name: "index_match_players_on_match_team_id"
    t.index ["player_id"], name: "index_match_players_on_player_id"
  end

  create_table "match_teams", force: :cascade do |t|
    t.bigint "match_id"
    t.string "outcome"
    t.integer "avg_rating", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["match_id"], name: "index_match_teams_on_match_id"
  end

  create_table "matches", force: :cascade do |t|
    t.date "started_at"
    t.date "ended_at"
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "username"
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
