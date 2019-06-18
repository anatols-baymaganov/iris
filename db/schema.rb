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

ActiveRecord::Schema.define(version: 2019_06_18_110527) do

  create_table "project_versions", force: :cascade do |t|
    t.integer "project_id"
    t.string "key", null: false
    t.string "value"
    t.index ["project_id", "key"], name: "index_project_versions_on_project_id_and_key", unique: true
    t.index ["project_id"], name: "index_project_versions_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.integer "origin_id", null: false
    t.string "name", null: false
    t.string "url", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_projects_on_name", unique: true
    t.index ["origin_id"], name: "index_projects_on_origin_id", unique: true
    t.index ["url"], name: "index_projects_on_url", unique: true
  end

  create_table "versions_settings", force: :cascade do |t|
    t.string "key", null: false
    t.text "value", null: false
    t.index ["key"], name: "index_versions_settings_on_key", unique: true
  end

end
