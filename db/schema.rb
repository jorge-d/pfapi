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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120301183200) do

  create_table "games", :force => true do |t|
    t.string   "name"
    t.string   "api_key"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "last_positions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "zone_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "last_positions", ["user_id"], :name => "index_last_positions_on_user_id"
  add_index "last_positions", ["zone_id"], :name => "index_last_positions_on_zone_id"

  create_table "scores", :force => true do |t|
    t.integer  "value"
    t.integer  "zone_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "game_id"
  end

  add_index "scores", ["game_id"], :name => "index_scores_on_game_id"
  add_index "scores", ["user_id"], :name => "index_scores_on_user_id"
  add_index "scores", ["zone_id"], :name => "index_scores_on_zone_id"

  create_table "unlocked_zones", :force => true do |t|
    t.integer  "user_id"
    t.integer  "zone_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "unlocked_zones", ["user_id"], :name => "index_unlocked_zones_on_user_id"
  add_index "unlocked_zones", ["zone_id"], :name => "index_unlocked_zones_on_zone_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.integer  "salt"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "encrypted_password"
  end

  create_table "zones", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
