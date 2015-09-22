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

ActiveRecord::Schema.define(version: 20150921134535) do

  create_table "abonenty", id: false, force: :cascade do |t|
    t.integer "num",        limit: 4
    t.string  "telefon",    limit: 10
    t.string  "kode",       limit: 15
    t.string  "adres",      limit: 30
    t.date    "dat"
    t.time    "tim"
    t.integer "cost",       limit: 4
    t.integer "balans",     limit: 4
    t.integer "poezdok",    limit: 4
    t.integer "otlog",      limit: 4
    t.integer "priz",       limit: 4
    t.string  "fio",        limit: 30
    t.string  "telefon2",   limit: 10
    t.date    "first_d"
    t.time    "first_t"
    t.integer "first_c",    limit: 4
    t.string  "first_p",    limit: 10
    t.string  "first_a",    limit: 25
    t.date    "second_d"
    t.time    "second_t"
    t.integer "second_c",   limit: 4
    t.string  "second_p",   limit: 10
    t.string  "second_a",   limit: 25
    t.date    "third_d"
    t.time    "third_t"
    t.integer "third_c",    limit: 4
    t.string  "third_p",    limit: 10
    t.string  "third_a",    limit: 25
    t.date    "fourth_d"
    t.time    "fourth_t"
    t.integer "fourth_c",   limit: 4
    t.string  "fourth_p",   limit: 10
    t.string  "fourth_a",   limit: 25
    t.date    "fifth_d"
    t.time    "fifth_t"
    t.integer "fifth_c",    limit: 4
    t.string  "fifth_p",    limit: 10
    t.string  "fifth_a",    limit: 25
    t.date    "sixth_d"
    t.time    "sixth_t"
    t.integer "sixth_c",    limit: 4
    t.string  "sixth_p",    limit: 10
    t.string  "sixth_a",    limit: 25
    t.date    "seventh_d"
    t.time    "seventh_t"
    t.integer "seventh_c",  limit: 4
    t.string  "seventh_p",  limit: 10
    t.string  "seventh_a",  limit: 25
    t.integer "num_f",      limit: 4
    t.date    "eigth_d"
    t.time    "eigth_t"
    t.integer "eigth_c",    limit: 4
    t.string  "eigth_p",    limit: 10
    t.string  "eigth_a",    limit: 25
    t.string  "nineth_a",   limit: 25
    t.string  "nineth_p",   limit: 10
    t.integer "nineth_c",   limit: 4
    t.time    "nineth_t"
    t.date    "nineth_d"
    t.date    "tenth_d"
    t.time    "tenth_t"
    t.integer "tenth_c",    limit: 4
    t.string  "tenth_p",    limit: 10
    t.string  "tenth_a",    limit: 25
    t.string  "eleventh_a", limit: 25
    t.string  "eleventh_p", limit: 10
    t.integer "eleventh_c", limit: 4
    t.time    "eleventh_t"
    t.date    "eleventh_d"
    t.integer "first_m",    limit: 4
    t.integer "second_m",   limit: 4
    t.integer "third_m",    limit: 4
    t.integer "fourth_m",   limit: 4
    t.integer "fifth_m",    limit: 4
    t.integer "sixth_m",    limit: 4
    t.integer "seventh_m",  limit: 4
    t.integer "eigth_m",    limit: 4
    t.integer "nineth_m",   limit: 4
    t.integer "tenth_m",    limit: 4
    t.integer "eleventh_m", limit: 4
    t.date    "d_12"
    t.time    "t_12"
    t.integer "c_12",       limit: 4
    t.string  "p_12",       limit: 10
    t.string  "a_12",       limit: 25
    t.integer "m_12",       limit: 4
    t.date    "d_13"
    t.time    "t_13"
    t.integer "c_13",       limit: 4
    t.string  "p_13",       limit: 10
    t.string  "a_13",       limit: 25
    t.integer "m_13",       limit: 4
    t.date    "d_14"
    t.time    "t_14"
    t.integer "c_14",       limit: 4
    t.string  "p_14",       limit: 10
    t.string  "a_14",       limit: 25
    t.integer "m_14",       limit: 4
    t.date    "d_15"
    t.time    "t_15"
    t.integer "c_15",       limit: 4
    t.string  "p_15",       limit: 10
    t.string  "a_15",       limit: 25
    t.integer "m_15",       limit: 4
    t.date    "d_16"
    t.time    "t_16"
    t.integer "c_16",       limit: 4
    t.string  "p_16",       limit: 10
    t.string  "a_16",       limit: 25
    t.integer "m_16",       limit: 4
    t.integer "vip",        limit: 4
  end

  create_table "cars", id: false, force: :cascade do |t|
    t.integer "num",        limit: 4
    t.date    "begin_date"
    t.time    "begin_time"
    t.date    "end_date"
    t.time    "end_time"
    t.integer "summa",      limit: 4
    t.integer "week",       limit: 4
    t.string  "telef",      limit: 10
  end

  create_table "changeqcars", force: :cascade do |t|
    t.integer  "car",        limit: 4
    t.integer  "row",        limit: 4
    t.integer  "state",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cqueue", id: false, force: :cascade do |t|
    t.integer "num",   limit: 4
    t.integer "car",   limit: 4
    t.integer "state", limit: 4
    t.string  "mesto", limit: 10
    t.integer "row",   limit: 4
    t.integer "col",   limit: 4
  end

  create_table "defsets", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "value",      limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "disp", id: false, force: :cascade do |t|
    t.integer "num",     limit: 4
    t.integer "day",     limit: 4
    t.integer "week",    limit: 4
    t.integer "working", limit: 4
  end

  create_table "logs", force: :cascade do |t|
    t.string   "user",       limit: 255
    t.string   "ip",         limit: 255
    t.text     "parameters", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logs", ["created_at"], name: "index_logs_on_created_at", using: :btree
  add_index "logs", ["user"], name: "index_logs_on_user", using: :btree

  create_table "point_queues", force: :cascade do |t|
    t.integer  "point_id",   limit: 4
    t.integer  "car",        limit: 4
    t.integer  "state",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "point_queues", ["car"], name: "car", unique: true, using: :btree

  create_table "points", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "smsmsgs", force: :cascade do |t|
    t.integer  "nozak",      limit: 4
    t.string   "notel",      limit: 255
    t.string   "txtsms",     limit: 255
    t.integer  "sent",       limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "streets", id: false, force: :cascade do |t|
    t.string "street", limit: 50
  end

  create_table "tracks", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.decimal  "lon",                  precision: 13, scale: 10
    t.decimal  "lat",                  precision: 13, scale: 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "login",           limit: 255
    t.string   "password",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "car",             limit: 4
    t.string   "group",           limit: 255,   default: "driver"
    t.string   "ip",              limit: 255
    t.datetime "alarm"
    t.text     "settings",        limit: 65535
    t.string   "monetary_unit",   limit: 255,   default: "руб"
    t.integer  "monetary_credit", limit: 4,     default: 0
    t.string   "cardesc",         limit: 255
  end

  create_table "zakazi", id: false, force: :cascade do |t|
    t.integer "zakaz",     limit: 4,   null: false
    t.string  "telefon",   limit: 10
    t.string  "kode",      limit: 10
    t.date    "dat"
    t.time    "tim"
    t.string  "adres",     limit: 25
    t.integer "car",       limit: 4
    t.time    "beg"
    t.time    "en"
    t.string  "place_end", limit: 25
    t.integer "cost",      limit: 4
    t.string  "priznak",   limit: 10
    t.string  "memo",      limit: 200
    t.string  "predvar",   limit: 10
    t.integer "working",   limit: 4
    t.integer "uvedomlen", limit: 4
    t.integer "vip",       limit: 4
  end

  create_table "zvonki", primary_key: "num", force: :cascade do |t|
    t.string  "telefon",   limit: 10
    t.string  "kode",      limit: 10
    t.date    "dat"
    t.time    "tim"
    t.string  "adres",     limit: 25
    t.integer "car",       limit: 4
    t.time    "beg"
    t.time    "en"
    t.integer "cost",      limit: 4
    t.string  "priznak",   limit: 10
    t.integer "zakaz",     limit: 4
    t.string  "place_end", limit: 25
    t.string  "memo",      limit: 200
  end

end
