class CreateChannelFilterTerms < ActiveRecord::Migration[8.1]
  def change
    create_table :channel_filter_terms do |t|
      t.references :user, null: false, foreign_key: true
      t.references :channel, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end

    add_index :channel_filter_terms, [ :user_id, :channel_id, :name ], unique: true
  end
end
