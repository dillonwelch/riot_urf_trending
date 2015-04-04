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

ActiveRecord::Schema.define(version: 20150404103150) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "champion_api_data", force: :cascade do |t|
    t.integer  "champion_id"
    t.json     "raw_api_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "champion_api_data", ["champion_id"], name: "index_champion_api_data_on_champion_id", using: :btree

  create_table "champion_matches", force: :cascade do |t|
    t.integer  "champion_id"
    t.integer  "match_id"
    t.boolean  "victory"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kills"
    t.integer  "deaths"
    t.integer  "assists"
  end

  add_index "champion_matches", ["assists"], name: "index_champion_matches_on_assists", using: :btree
  add_index "champion_matches", ["champion_id", "victory"], name: "index_champion_matches_on_champion_id_and_victory", using: :btree
  add_index "champion_matches", ["deaths"], name: "index_champion_matches_on_deaths", using: :btree
  add_index "champion_matches", ["kills"], name: "index_champion_matches_on_kills", using: :btree
  add_index "champion_matches", ["match_id", "victory"], name: "index_champion_matches_on_match_id_and_victory", using: :btree

  create_table "champions", force: :cascade do |t|
    t.integer  "riot_id"
    t.string   "name"
    t.string   "primary_role"
    t.string   "secondary_role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "champions", ["name"], name: "index_champions_on_name", unique: true, using: :btree
  add_index "champions", ["primary_role"], name: "index_champions_on_primary_role", using: :btree
  add_index "champions", ["riot_id"], name: "index_champions_on_riot_id", unique: true, using: :btree
  add_index "champions", ["secondary_role"], name: "index_champions_on_secondary_role", using: :btree

  create_table "match_api_data", force: :cascade do |t|
    t.integer  "match_id"
    t.json     "raw_api_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "match_api_data", ["match_id"], name: "index_match_api_data_on_match_id", using: :btree

  create_table "matches", force: :cascade do |t|
    t.integer  "game_id"
    t.string   "region"
    t.integer  "start_time",    limit: 8
    t.integer  "duration",      limit: 8
    t.json     "champion_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["game_id", "region"], name: "index_matches_on_game_id_and_region", unique: true, using: :btree
  add_index "matches", ["region"], name: "index_matches_on_region", using: :btree

  add_foreign_key "champion_api_data", "champions", name: "fk_rails_champion_api_data_champions", on_delete: :cascade
  add_foreign_key "champion_matches", "champions", name: "fk_rails_champion_matches_champions", on_delete: :cascade
  add_foreign_key "champion_matches", "matches", name: "fk_rails_champion_matches_matches", on_delete: :cascade
  add_foreign_key "match_api_data", "matches", name: "fk_rails_match_api_data_matches", on_delete: :cascade
end
