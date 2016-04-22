class CreateDisps < ActiveRecord::Migration
  def change
    create_table :disps do |t|
      t.integer :num
      t.integer :day
      t.integer :week
      t.integer :working

      t.timestamps null: false
    end
  end
end
