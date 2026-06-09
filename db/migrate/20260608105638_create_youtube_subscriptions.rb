class CreateYoutubeSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :youtube_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :channel, null: false, foreign_key: true

      t.timestamps
    end

    add_index :youtube_subscriptions, [ :user_id, :channel_id ], unique: true
  end
end
