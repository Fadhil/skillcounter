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

ActiveRecord::Schema.define(version: 20141209131016) do

  create_table "admins", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendance_list", force: true do |t|
    t.integer "user_id"
    t.integer "event_id"
  end

  add_index "attendance_list", ["event_id"], name: "index_attendance_list_on_event_id"
  add_index "attendance_list", ["user_id"], name: "index_attendance_list_on_user_id"

  create_table "contact_numbers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organizer_id"
  end

  add_index "contact_numbers", ["organizer_id"], name: "index_contact_numbers_on_organizer_id"

  create_table "events", force: true do |t|
    t.string   "event_name"
    t.text     "description"
    t.string   "location"
    t.string   "start_date_time"
    t.string   "end_date_time"
    t.integer  "venue_capacity"
    t.integer  "ticket_quantity"
    t.string   "event_page_url"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organizer_id"
    t.integer  "point"
    t.string   "category"
    t.string   "bio_url"
    t.string   "speaker"
    t.string   "speaker_bio_file_name"
    t.string   "speaker_bio_content_type"
    t.integer  "speaker_bio_file_size"
    t.datetime "speaker_bio_updated_at"
    t.string   "schedule_file_name"
    t.string   "schedule_content_type"
    t.integer  "schedule_file_size"
    t.datetime "schedule_updated_at"
    t.string   "poster_file_name"
    t.string   "poster_content_type"
    t.integer  "poster_file_size"
    t.datetime "poster_updated_at"
  end

  add_index "events", ["organizer_id"], name: "index_events_on_organizer_id"

  create_table "roles", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "roles_users", force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], name: "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id"

  create_table "user_logins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "role"
    t.string   "type"
    t.string   "licence_number"
    t.string   "ic_number"
    t.string   "contact_number"
    t.integer  "current_points"
    t.integer  "expiring_points"
    t.string   "address"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "biodata_file_name"
    t.string   "biodata_content_type"
    t.integer  "biodata_file_size"
    t.datetime "biodata_updated_at"
    t.string   "schedule_file_name"
    t.string   "schedule_content_type"
    t.integer  "schedule_file_size"
    t.datetime "schedule_updated_at"
    t.string   "member_since"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
