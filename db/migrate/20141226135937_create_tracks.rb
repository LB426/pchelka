class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.integer :user_id
      t.decimal :lon, precision: 13, scale: 10
      t.decimal :lat, precision: 13, scale: 10
      t.timestamps
    end
  end
end
