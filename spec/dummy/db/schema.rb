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

ActiveRecord::Schema.define(version: 20141107181915) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "has_vcards_addresses", force: true do |t|
    t.string   "post_office_box"
    t.string   "extended_address"
    t.string   "street_address"
    t.string   "locality"
    t.string   "region"
    t.string   "postal_code"
    t.string   "country_name"
    t.integer  "vcard_id"
    t.string   "address_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "has_vcards_addresses", ["vcard_id"], name: "addresses_vcard_id_index", using: :btree

  create_table "has_vcards_phone_numbers", force: true do |t|
    t.string   "number"
    t.string   "phone_number_type"
    t.integer  "vcard_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "has_vcards_phone_numbers", ["phone_number_type"], name: "index_has_vcards_phone_numbers_on_phone_number_type", using: :btree
  add_index "has_vcards_phone_numbers", ["vcard_id"], name: "phone_numbers_vcard_id_index", using: :btree

  create_table "has_vcards_vcards", force: true do |t|
    t.string   "full_name"
    t.string   "nickname"
    t.string   "family_name"
    t.string   "given_name"
    t.string   "additional_name"
    t.string   "honorific_prefix"
    t.string   "honorific_suffix"
    t.boolean  "active",           default: true
    t.string   "type"
    t.integer  "reference_id"
    t.string   "reference_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "has_vcards_vcards", ["active"], name: "index_has_vcards_vcards_on_active", using: :btree
  add_index "has_vcards_vcards", ["reference_id", "reference_type"], name: "index_has_vcards_vcards_on_reference_id_and_reference_type", using: :btree

  create_table "somethings", force: true do |t|
    t.string "title"
  end

end
