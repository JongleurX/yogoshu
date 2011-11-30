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

ActiveRecord::Schema.define(:version => 20111128121949) do

  create_table "entries", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "approved"
    t.string   "source_language", :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "note"
  end

  create_table "entry_translations", :force => true do |t|
    t.integer  "entry_id"
    t.string   "locale"
    t.string   "term"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entry_translations", ["entry_id"], :name => "index_entry_translations_on_entry_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "encrypted_password", :limit => 40
    t.string   "salt",               :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
  end

end
