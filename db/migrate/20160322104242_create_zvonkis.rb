class CreateZvonkis < ActiveRecord::Migration
  def change
    create_table :zvonkis do |t|
      t.integer :num
      t.string :telefon
      t.string :kode
      t.date :dat
      t.time :tim
      t.string :adres
      t.integer :car
      t.time :beg
      t.time :en
      t.integer :cost
      t.string :priznak
      t.integer :zakaz
      t.string :place_end
      t.string :memo

      t.timestamps null: false
    end
  end
end
