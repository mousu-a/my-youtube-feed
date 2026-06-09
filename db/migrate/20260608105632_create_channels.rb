class CreateChannels < ActiveRecord::Migration[8.1]
  def change
    create_table :channels do |t|
      t.string :youtube_channel_id, null: false
      t.string :name, null: false
      t.string :url, null: false
      t.string :icon_url, null: false
      t.string :videos_playlist_id, null: false
      t.datetime :videos_refreshed_at

      t.timestamps
    end

    add_index :channels, :youtube_channel_id, unique: true
  end
end
