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

ActiveRecord::Schema.define(version: 20160322105213) do

  create_table "changeqcars", force: :cascade do |t|
    t.integer  "car",        limit: 4
    t.integer  "row",        limit: 4
    t.integer  "state",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "defsets", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "value",      limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "ledgers", id: false, force: :cascade do |t|
    t.string   "origin",    limit: 255, null: false
    t.string   "recipient", limit: 255, null: false
    t.integer  "amount",    limit: 4,   null: false
    t.string   "operation", limit: 255, null: false
    t.datetime "when",                  null: false
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

  create_table "streets", force: :cascade do |t|
    t.string   "street",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
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
    t.datetime "tcredup"
    t.boolean  "mpinq"
  end

  create_table "zakazis", force: :cascade do |t|
    t.integer  "zakaz",      limit: 4
    t.string   "telefon",    limit: 255
    t.string   "kode",       limit: 255
    t.date     "dat"
    t.time     "tim"
    t.string   "adres",      limit: 255
    t.integer  "car",        limit: 4
    t.time     "beg"
    t.time     "en"
    t.string   "place_end",  limit: 255
    t.integer  "cost",       limit: 4
    t.string   "priznak",    limit: 255
    t.string   "memo",       limit: 255
    t.string   "predvar",    limit: 255
    t.integer  "working",    limit: 4
    t.integer  "uvedomlen",  limit: 4
    t.integer  "vip",        limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "zvonkis", force: :cascade do |t|
    t.integer  "num",        limit: 4
    t.string   "telefon",    limit: 255
    t.string   "kode",       limit: 255
    t.date     "dat"
    t.time     "tim"
    t.string   "adres",      limit: 255
    t.integer  "car",        limit: 4
    t.time     "beg"
    t.time     "en"
    t.integer  "cost",       limit: 4
    t.string   "priznak",    limit: 255
    t.integer  "zakaz",      limit: 4
    t.string   "place_end",  limit: 255
    t.string   "memo",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
