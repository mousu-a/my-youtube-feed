class CreateVideos < ActiveRecord::Migration[8.1]
  def change
    create_table :videos do |t|
      t.references :channel, null: false, foreign_key: true
      t.string :youtube_video_id, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.string :thumbnail_url, null: false
      t.string :live_broadcast_status, null: false
      t.datetime :published_at, null: false
      t.datetime :live_start_time
      t.datetime :live_end_time
      t.datetime :data_refreshed_at, null: false

      t.timestamps
    end

    add_index :videos, :youtube_video_id, unique: true
  end
end
