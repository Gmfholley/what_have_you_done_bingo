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

ActiveRecord::Schema.define(version: 20160103060918) do

  create_table "cards", force: :cascade do |t|
    t.integer  "template_id"
    t.integer  "user_id"
    t.string   "token"
    t.boolean  "is_public"
    t.integer  "num_bingos"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "cards", ["token"], name: "index_cards_on_token"

  create_table "organization_users", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "token"
  end

  add_index "organizations", ["token"], name: "index_organizations_on_token"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "squares", force: :cascade do |t|
    t.integer  "position_x"
    t.integer  "position_y"
    t.string   "picture"
    t.string   "question"
    t.boolean  "free_space"
    t.integer  "template_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "templates", force: :cascade do |t|
    t.integer  "size"
    t.integer  "organization_id"
    t.string   "name"
    t.boolean  "is_public"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "token"
    t.integer  "rating"
  end

  add_index "templates", ["token"], name: "index_templates_on_token"

  create_table "users", force: :cascade do |t|
    t.string   "email",                           null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "profile_picture"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token"

end
