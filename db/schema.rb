# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150331070655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "champion_matches", force: :cascade do |t|
    t.integer  "champion_id"
    t.integer  "match_id"
    t.boolean  "victory"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "champion_matches", ["champion_id", "victory"], name: "index_champion_matches_on_champion_id_and_victory", using: :btree
  add_index "champion_matches", ["match_id", "victory"], name: "index_champion_matches_on_match_id_and_victory", using: :btree

  create_table "champions", force: :cascade do |t|
    t.integer  "riot_id"
    t.string   "name"
    t.json     "raw_api_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "champions", ["name"], name: "index_champions_on_name", using: :btree
  add_index "champions", ["riot_id"], name: "index_champions_on_riot_id", using: :btree

  create_table "matches", force: :cascade do |t|
    t.integer  "game_id"
    t.json     "champion_data"
    t.json     "raw_api_data"
    t.integer  "start_time",    limit: 8
    t.integer  "duration",      limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["game_id"], name: "index_matches_on_game_id", using: :btree

  add_foreign_key "champion_matches", "champions", name: "fk_rails_champion_matches_champions"
  add_foreign_key "champion_matches", "matches", name: "fk_rails_champion_matches_matches"
end
