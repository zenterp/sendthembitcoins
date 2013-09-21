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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130921191611) do

  create_table "coinbase_oauthorizations", :force => true do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "token"
    t.string   "refresh_token"
    t.integer  "expires_at"
    t.boolean  "expires"
    t.string   "bitcoin_address"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "coinbase_oauthorizations", ["uid"], :name => "index_coinbase_oauthorizations_on_uid"

  create_table "gifts", :force => true do |t|
    t.string   "coinbase_invoice_id"
    t.string   "recipient_bitcoin_address"
    t.float    "bitcoin_amount"
    t.string   "recipient_twitter_username"
    t.datetime "funded_at"
    t.datetime "retrieved_at"
    t.datetime "revoked_at"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "recipient_uid"
    t.string   "network"
    t.string   "recipient_github_username"
  end

  add_index "gifts", ["recipient_github_username"], :name => "index_gifts_on_recipient_github_username"

end
