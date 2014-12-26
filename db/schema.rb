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

ActiveRecord::Schema.define(version: 20141210122103) do

  create_table "abonenty", id: false, force: true do |t|
    t.integer "num"
    t.string  "telefon",    limit: 10
    t.string  "kode",       limit: 15
    t.string  "adres",      limit: 30
    t.date    "dat"
    t.time    "tim"
    t.integer "cost"
    t.integer "balans"
    t.integer "poezdok"
    t.integer "otlog"
    t.integer "priz"
    t.string  "fio",        limit: 30
    t.string  "telefon2",   limit: 10
    t.date    "first_d"
    t.time    "first_t"
    t.integer "first_c"
    t.string  "first_p",    limit: 10
    t.string  "first_a",    limit: 25
    t.date    "second_d"
    t.time    "second_t"
    t.integer "second_c"
    t.string  "second_p",   limit: 10
    t.string  "second_a",   limit: 25
    t.date    "third_d"
    t.time    "third_t"
    t.integer "third_c"
    t.string  "third_p",    limit: 10
    t.string  "third_a",    limit: 25
    t.date    "fourth_d"
    t.time    "fourth_t"
    t.integer "fourth_c"
    t.string  "fourth_p",   limit: 10
    t.string  "fourth_a",   limit: 25
    t.date    "fifth_d"
    t.time    "fifth_t"
    t.integer "fifth_c"
    t.string  "fifth_p",    limit: 10
    t.string  "fifth_a",    limit: 25
    t.date    "sixth_d"
    t.time    "sixth_t"
    t.integer "sixth_c"
    t.string  "sixth_p",    limit: 10
    t.string  "sixth_a",    limit: 25
    t.date    "seventh_d"
    t.time    "seventh_t"
    t.integer "seventh_c"
    t.string  "seventh_p",  limit: 10
    t.string  "seventh_a",  limit: 25
    t.integer "num_f"
    t.date    "eigth_d"
    t.time    "eigth_t"
    t.integer "eigth_c"
    t.string  "eigth_p",    limit: 10
    t.string  "eigth_a",    limit: 25
    t.string  "nineth_a",   limit: 25
    t.string  "nineth_p",   limit: 10
    t.integer "nineth_c"
    t.time    "nineth_t"
    t.date    "nineth_d"
    t.date    "tenth_d"
    t.time    "tenth_t"
    t.integer "tenth_c"
    t.string  "tenth_p",    limit: 10
    t.string  "tenth_a",    limit: 25
    t.string  "eleventh_a", limit: 25
    t.string  "eleventh_p", limit: 10
    t.integer "eleventh_c"
    t.time    "eleventh_t"
    t.date    "eleventh_d"
    t.integer "first_m"
    t.integer "second_m"
    t.integer "third_m"
    t.integer "fourth_m"
    t.integer "fifth_m"
    t.integer "sixth_m"
    t.integer "seventh_m"
    t.integer "eigth_m"
    t.integer "nineth_m"
    t.integer "tenth_m"
    t.integer "eleventh_m"
    t.date    "d_12"
    t.time    "t_12"
    t.integer "c_12"
    t.string  "p_12",       limit: 10
    t.string  "a_12",       limit: 25
    t.integer "m_12"
    t.date    "d_13"
    t.time    "t_13"
    t.integer "c_13"
    t.string  "p_13",       limit: 10
    t.string  "a_13",       limit: 25
    t.integer "m_13"
    t.date    "d_14"
    t.time    "t_14"
    t.integer "c_14"
    t.string  "p_14",       limit: 10
    t.string  "a_14",       limit: 25
    t.integer "m_14"
    t.date    "d_15"
    t.time    "t_15"
    t.integer "c_15"
    t.string  "p_15",       limit: 10
    t.string  "a_15",       limit: 25
    t.integer "m_15"
    t.date    "d_16"
    t.time    "t_16"
    t.integer "c_16"
    t.string  "p_16",       limit: 10
    t.string  "a_16",       limit: 25
    t.integer "m_16"
    t.integer "vip"
  end

  create_table "cars", id: false, force: true do |t|
    t.integer "num"
    t.date    "begin_date"
    t.time    "begin_time"
    t.date    "end_date"
    t.time    "end_time"
    t.integer "summa"
    t.integer "week"
    t.string  "telef",      limit: 10
  end

  create_table "changeqcars", force: true do |t|
    t.integer  "car"
    t.integer  "row"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cqueue", id: false, force: true do |t|
    t.integer "num"
    t.integer "car"
    t.integer "state"
    t.string  "mesto", limit: 10
    t.integer "row"
    t.integer "col"
  end

  create_table "disp", id: false, force: true do |t|
    t.integer "num"
    t.integer "day"
    t.integer "week"
    t.integer "working"
  end

  create_table "logs", force: true do |t|
    t.string   "user"
    t.string   "ip"
    t.text     "parameters"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logs", ["created_at"], name: "index_logs_on_created_at", using: :btree
  add_index "logs", ["user"], name: "index_logs_on_user", using: :btree

  create_table "point_queues", force: true do |t|
    t.integer  "point_id"
    t.integer  "car"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "point_queues", ["car"], name: "car", unique: true, using: :btree

  create_table "points", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "streets", id: false, force: true do |t|
    t.string "street", limit: 50
  end

  create_table "tracks", force: true do |t|
    t.integer  "user_id"
    t.decimal  "lon",        precision: 13, scale: 10
    t.decimal  "lat",        precision: 13, scale: 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "car"
    t.string   "group",      default: "driver"
    t.string   "ip"
  end

  create_table "zakazi", id: false, force: true do |t|
    t.integer "zakaz",                 null: false
    t.string  "telefon",   limit: 10
    t.string  "kode",      limit: 10
    t.date    "dat"
    t.time    "tim"
    t.string  "adres",     limit: 25
    t.integer "car"
    t.time    "beg"
    t.time    "en"
    t.string  "place_end", limit: 25
    t.integer "cost"
    t.string  "priznak",   limit: 10
    t.string  "memo",      limit: 200
    t.string  "predvar",   limit: 10
    t.integer "working"
    t.integer "uvedomlen"
    t.integer "vip"
  end

  create_table "zvonki", primary_key: "num", force: true do |t|
    t.string  "telefon",   limit: 10
    t.string  "kode",      limit: 10
    t.date    "dat"
    t.time    "tim"
    t.string  "adres",     limit: 25
    t.integer "car"
    t.time    "beg"
    t.time    "en"
    t.integer "cost"
    t.string  "priznak",   limit: 10
    t.integer "zakaz"
    t.string  "place_end", limit: 25
    t.string  "memo",      limit: 200
  end

end
