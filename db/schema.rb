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

ActiveRecord::Schema.define(version: 20180128192036) do

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "host_id", null: false
    t.string "event_name", null: false
    t.text "description", limit: 255
    t.datetime "event_start", null: false
    t.datetime "event_end", null: false
    t.integer "capacity", null: false
    t.datetime "rsvp_start", null: false
    t.datetime "rsvp_end", null: false
    t.integer "event_type", limit: 1, null: false
    t.string "venue_addr1", null: false
    t.string "venue_addr2"
    t.string "venue_city", null: false
    t.string "venue_state", null: false
    t.string "venue_zip", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["host_id"], name: "index_events_on_host_id"
  end

  create_table "hosts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "business_name", null: false
    t.string "email_addr", null: false
    t.string "passwd", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email_addr", null: false
    t.string "passwd", limit: 64, null: false
    t.string "phone", null: false
    t.string "addr1"
    t.string "addr2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
