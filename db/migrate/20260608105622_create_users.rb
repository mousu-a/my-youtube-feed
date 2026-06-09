class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :avatar_url, null: false
      t.boolean :admin, null: false, default: false

      t.timestamps
    end

    add_index :users, [ :provider, :uid ], unique: true
  end
end
