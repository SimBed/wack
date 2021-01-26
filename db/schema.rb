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

ActiveRecord::Schema.define(version: 2021_01_22_175306) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attempts", force: :cascade do |t|
    t.datetime "doa"
    t.text "summary"
    t.bigint "user_id"
    t.bigint "workout_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_attempts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_attempts_on_user_id"
    t.index ["workout_id", "created_at"], name: "index_attempts_on_workout_id_and_created_at"
    t.index ["workout_id"], name: "index_attempts_on_workout_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.string "name"
    t.datetime "start_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "microposts", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id"
    t.bigint "workout_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_microposts_on_user_id"
    t.index ["workout_id", "created_at"], name: "index_microposts_on_workout_id_and_created_at"
    t.index ["workout_id"], name: "index_microposts_on_workout_id"
  end

  create_table "rel_user_workouts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "workout_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "workout_id"], name: "index_rel_user_workouts_on_user_id_and_workout_id", unique: true
    t.index ["user_id"], name: "index_rel_user_workouts_on_user_id"
    t.index ["workout_id"], name: "index_rel_user_workouts_on_workout_id"
  end

  create_table "schedulings", force: :cascade do |t|
    t.string "name"
    t.datetime "start_time"
    t.integer "workout_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_schedulings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean "demo", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "workouts", force: :cascade do |t|
    t.string "name"
    t.string "style"
    t.string "url"
    t.integer "length"
    t.string "intensity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "spacesays"
    t.boolean "equipment"
    t.string "addedby"
    t.string "brand"
    t.string "eqpitems"
    t.string "bodyfocus"
    t.string "short_name"
  end

  add_foreign_key "attempts", "users"
  add_foreign_key "attempts", "workouts"
  add_foreign_key "microposts", "users"
  add_foreign_key "microposts", "workouts"
  add_foreign_key "schedulings", "users"
end
