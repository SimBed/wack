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

ActiveRecord::Schema[7.0].define(version: 2023_07_08_135453) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attempts", force: :cascade do |t|
    t.datetime "doa", precision: nil
    t.text "summary"
    t.bigint "user_id"
    t.bigint "workout_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id", "created_at"], name: "index_attempts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_attempts_on_user_id"
    t.index ["workout_id", "created_at"], name: "index_attempts_on_workout_id_and_created_at"
    t.index ["workout_id"], name: "index_attempts_on_workout_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.string "name"
    t.datetime "start_time", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "microposts", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id"
    t.bigint "workout_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_microposts_on_user_id"
    t.index ["workout_id", "created_at"], name: "index_microposts_on_workout_id_and_created_at"
    t.index ["workout_id"], name: "index_microposts_on_workout_id"
  end

  create_table "rel_user_workouts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "workout_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id", "workout_id"], name: "index_rel_user_workouts_on_user_id_and_workout_id", unique: true
    t.index ["user_id"], name: "index_rel_user_workouts_on_user_id"
    t.index ["workout_id"], name: "index_rel_user_workouts_on_workout_id"
  end

  create_table "schedulings", force: :cascade do |t|
    t.string "name"
    t.datetime "start_time", precision: nil
    t.integer "workout_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_schedulings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at", precision: nil
    t.string "reset_digest"
    t.datetime "reset_sent_at", precision: nil
    t.boolean "demo", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "workouts", force: :cascade do |t|
    t.string "name"
    t.string "style"
    t.string "url"
    t.integer "length"
    t.string "intensity"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "spacesays"
    t.boolean "equipment"
    t.string "addedby"
    t.string "brand"
    t.string "eqpitems"
    t.string "bodyfocus"
    t.string "short_name"
    t.index ["name"], name: "index_workouts_on_name", unique: true
    t.index ["url"], name: "index_workouts_on_url", unique: true
  end

  add_foreign_key "attempts", "users"
  add_foreign_key "attempts", "workouts"
  add_foreign_key "microposts", "users"
  add_foreign_key "microposts", "workouts"
  add_foreign_key "schedulings", "users"
end
