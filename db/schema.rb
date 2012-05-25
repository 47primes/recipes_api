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

ActiveRecord::Schema.define(:version => 20120518051525) do

  create_table "cookbooks", :force => true do |t|
    t.integer  "cook_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "cookbooks", ["cook_id"], :name => "index_cookbooks_on_cook_id"
  add_index "cookbooks", ["description"], :name => "index_cookbooks_on_description"
  add_index "cookbooks", ["name"], :name => "index_cookbooks_on_name"

  create_table "cooks", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.string   "auth_key"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "food_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "recipes", :force => true do |t|
    t.integer  "cook_id"
    t.integer  "cookbook_id"
    t.string   "name"
    t.string   "category"
    t.text     "ingredients"
    t.text     "directions"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "recipes", ["cook_id"], :name => "index_recipes_on_cook_id"
  add_index "recipes", ["cookbook_id"], :name => "index_recipes_on_cookbook_id"
  add_index "recipes", ["name"], :name => "index_recipes_on_name"

end
