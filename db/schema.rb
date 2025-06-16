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

ActiveRecord::Schema[7.1].define(version: 2025_06_16_215415) do
  create_table "clients", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "phone"
    t.integer "credit_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credit_score"], name: "index_clients_on_credit_score"
    t.index ["email"], name: "index_clients_on_email", unique: true
  end

  create_table "lenders", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "minimum_loan_amount", precision: 10, scale: 2
    t.decimal "maximum_loan_amount", precision: 10, scale: 2
    t.decimal "interest_rate", precision: 5, scale: 2
    t.integer "minimum_credit_score", default: 300
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interest_rate"], name: "index_lenders_on_interest_rate"
    t.index ["minimum_credit_score"], name: "index_lenders_on_minimum_credit_score"
  end

  create_table "loans", force: :cascade do |t|
    t.integer "client_id", null: false
    t.integer "lender_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id", "status"], name: "index_loans_on_client_id_and_status"
    t.index ["client_id"], name: "index_loans_on_client_id"
    t.index ["lender_id"], name: "index_loans_on_lender_id"
    t.index ["status"], name: "index_loans_on_status"
  end

  add_foreign_key "loans", "clients"
  add_foreign_key "loans", "lenders"
end
