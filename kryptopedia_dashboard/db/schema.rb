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

ActiveRecord::Schema[8.1].define(version: 2026_02_04_014245) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "devices", force: :cascade do |t|
    t.bigint "active_event_id"
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "owner_id"
    t.string "owner_type"
    t.datetime "updated_at", null: false
    t.index ["active_event_id"], name: "index_devices_on_active_event_id"
    t.index ["owner_type", "owner_id"], name: "index_devices_on_owner"
  end

  create_table "scouted_event_teams", force: :cascade do |t|
    t.datetime "deleted_at"
    t.bigint "scouted_event_id"
    t.bigint "team_id"
    t.datetime "updated_at"
    t.index ["scouted_event_id", "team_id"], name: "index_set_on_event_id_and_team_id", unique: true
    t.index ["scouted_event_id"], name: "index_scouted_event_teams_on_scouted_event_id"
    t.index ["team_id"], name: "index_scouted_event_teams_on_team_id"
  end

  create_table "scouted_events", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "team_id", null: false
    t.boolean "test"
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_scouted_events_on_team_id"
  end

  create_table "scouting_data_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "data"
    t.bigint "scouted_event_id", null: false
    t.bigint "team_member_id", null: false
    t.string "type"
    t.string "uid"
    t.datetime "updated_at", null: false
    t.index ["scouted_event_id"], name: "index_scouting_data_items_on_scouted_event_id"
    t.index ["team_member_id"], name: "index_scouting_data_items_on_team_member_id"
  end

  create_table "session_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "device_id", null: false
    t.datetime "expires_at"
    t.bigint "scouted_event_id", null: false
    t.bigint "session_id"
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_session_requests_on_device_id"
    t.index ["scouted_event_id"], name: "index_session_requests_on_scouted_event_id"
    t.index ["session_id"], name: "index_session_requests_on_session_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "auth_token"
    t.datetime "created_at", null: false
    t.bigint "owner_id"
    t.string "owner_type"
    t.datetime "updated_at", null: false
    t.index ["auth_token"], name: "index_sessions_on_auth_token", unique: true
    t.index ["owner_type", "owner_id"], name: "index_sessions_on_owner"
  end

  create_table "team_members", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.integer "email_code"
    t.datetime "email_code_sent_at"
    t.string "name"
    t.integer "role"
    t.bigint "team_id", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_members_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "number"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "devices", "scouted_events", column: "active_event_id"
  add_foreign_key "scouted_events", "teams"
  add_foreign_key "scouting_data_items", "scouted_events"
  add_foreign_key "scouting_data_items", "team_members"
  add_foreign_key "session_requests", "devices"
  add_foreign_key "session_requests", "scouted_events"
  add_foreign_key "session_requests", "sessions"
  add_foreign_key "team_members", "teams"
end
