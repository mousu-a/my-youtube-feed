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

ActiveRecord::Schema[8.1].define(version: 2026_06_08_105700) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "channel_filter_terms", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["channel_id"], name: "index_channel_filter_terms_on_channel_id"
    t.index ["user_id", "channel_id", "name"], name: "index_channel_filter_terms_on_user_id_and_channel_id_and_name", unique: true
    t.index ["user_id"], name: "index_channel_filter_terms_on_user_id"
  end

  create_table "channels", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "icon_url", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.string "videos_playlist_id", null: false
    t.datetime "videos_refreshed_at"
    t.string "youtube_channel_id", null: false
    t.index ["youtube_channel_id"], name: "index_channels_on_youtube_channel_id", unique: true
  end

  create_table "follows", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["channel_id"], name: "index_follows_on_channel_id"
    t.index ["user_id", "channel_id"], name: "index_follows_on_user_id_and_channel_id", unique: true
    t.index ["user_id"], name: "index_follows_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.string "avatar_url", null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "data_refreshed_at", null: false
    t.text "description", null: false
    t.string "live_broadcast_status", null: false
    t.datetime "live_end_time"
    t.datetime "live_start_time"
    t.datetime "published_at", null: false
    t.string "thumbnail_url", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "youtube_video_id", null: false
    t.index ["channel_id"], name: "index_videos_on_channel_id"
    t.index ["youtube_video_id"], name: "index_videos_on_youtube_video_id", unique: true
  end

  create_table "youtube_subscriptions", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["channel_id"], name: "index_youtube_subscriptions_on_channel_id"
    t.index ["user_id", "channel_id"], name: "index_youtube_subscriptions_on_user_id_and_channel_id", unique: true
    t.index ["user_id"], name: "index_youtube_subscriptions_on_user_id"
  end

  add_foreign_key "channel_filter_terms", "channels"
  add_foreign_key "channel_filter_terms", "users"
  add_foreign_key "follows", "channels"
  add_foreign_key "follows", "users"
  add_foreign_key "videos", "channels"
  add_foreign_key "youtube_subscriptions", "channels"
  add_foreign_key "youtube_subscriptions", "users"
end
