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

ActiveRecord::Schema[7.1].define(version: 2023_11_22_001349) do
  create_table "issues", force: :cascade do |t|
    t.integer "page_id", limit: 8
    t.text "sentence"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_issues_on_page_id"
  end

  create_table "pages", force: :cascade do |t|
    t.integer "site_id", limit: 8
    t.string "url"
    t.boolean "is_scraped", default: false
    t.boolean "is_scanned", default: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_pages_on_site_id"
    t.index ["url"], name: "index_pages_on_url"
  end

  create_table "sites", force: :cascade do |t|
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
