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

ActiveRecord::Schema[8.1].define(version: 2026_03_05_163254) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "devices", force: :cascade do |t|
    t.bigint "active_event_id"
    t.datetime "created_at", null: false
    t.datetime "last_sync"
    t.string "name"
    t.bigint "owner_id"
    t.string "owner_type"
    t.datetime "updated_at", null: false
    t.index ["active_event_id"], name: "index_devices_on_active_event_id"
    t.index ["owner_type", "owner_id"], name: "index_devices_on_owner"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "blue1_id"
    t.bigint "blue2_id"
    t.bigint "blue3_id"
    t.string "comp_level", null: false
    t.datetime "created_at", null: false
    t.integer "number", null: false
    t.bigint "red1_id"
    t.bigint "red2_id"
    t.bigint "red3_id"
    t.bigint "scouted_event_id", null: false
    t.datetime "updated_at", null: false
    t.index ["blue1_id"], name: "index_matches_on_blue1_id"
    t.index ["blue2_id"], name: "index_matches_on_blue2_id"
    t.index ["blue3_id"], name: "index_matches_on_blue3_id"
    t.index ["comp_level", "number"], name: "index_matches_on_comp_level_and_number", unique: true
    t.index ["red1_id"], name: "index_matches_on_red1_id"
    t.index ["red2_id"], name: "index_matches_on_red2_id"
    t.index ["red3_id"], name: "index_matches_on_red3_id"
    t.index ["scouted_event_id"], name: "index_matches_on_scouted_event_id"
  end

  create_table "preloaded_flags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "name"
    t.bigint "scouted_event_id", null: false
    t.datetime "updated_at", null: false
    t.index ["scouted_event_id"], name: "index_preloaded_flags_on_scouted_event_id"
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
    t.datetime "pit_map_cache_updated"
    t.boolean "tba_sync", default: false, null: false
    t.bigint "team_id", null: false
    t.boolean "test"
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_scouted_events_on_team_id"
  end

  create_table "scouting_data_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "data", null: false
    t.string "data_type", null: false
    t.datetime "deleted_at"
    t.bigint "scouted_event_id", null: false
    t.bigint "team_member_id"
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.index ["scouted_event_id"], name: "index_scouting_data_items_on_scouted_event_id"
    t.index ["team_member_id"], name: "index_scouting_data_items_on_team_member_id"
    t.index ["uid", "scouted_event_id"], name: "index_scouting_data_items_on_uid_and_scouted_event_id", unique: true
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "devices", "scouted_events", column: "active_event_id"
  add_foreign_key "matches", "scouted_events"
  add_foreign_key "matches", "teams", column: "blue1_id"
  add_foreign_key "matches", "teams", column: "blue2_id"
  add_foreign_key "matches", "teams", column: "blue3_id"
  add_foreign_key "matches", "teams", column: "red1_id"
  add_foreign_key "matches", "teams", column: "red2_id"
  add_foreign_key "matches", "teams", column: "red3_id"
  add_foreign_key "preloaded_flags", "scouted_events"
  add_foreign_key "scouted_events", "teams"
  add_foreign_key "scouting_data_items", "scouted_events"
  add_foreign_key "scouting_data_items", "team_members"
  add_foreign_key "session_requests", "devices"
  add_foreign_key "session_requests", "scouted_events"
  add_foreign_key "session_requests", "sessions"
  add_foreign_key "team_members", "teams"
end
