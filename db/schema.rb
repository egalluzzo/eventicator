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

ActiveRecord::Schema.define(:version => 20120812003231) do

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "location"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
  end

  add_index "events", ["start_date", "end_date"], :name => "index_events_on_start_date_and_end_date"

  create_table "talks", :force => true do |t|
    t.string   "title"
    t.string   "speaker"
    t.text     "description"
    t.string   "room"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "event_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "talks", ["event_id", "start_at"], :name => "index_talks_on_event_id_and_start_at"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["password_reset_token"], :name => "index_users_on_password_reset_token", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token", :unique => true

end
