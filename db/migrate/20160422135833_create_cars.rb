class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.integer :num
      t.date :begin_date
      t.time :begin_time
      t.date :end_date
      t.time :end_time
      t.integer :summa
      t.integer :week
      t.string :telef

      t.timestamps null: false
    end
  end
end
