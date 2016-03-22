class CreateZakazis < ActiveRecord::Migration
  def change
    create_table :zakazis do |t|
      t.integer :zakaz
      t.string :telefon
      t.string :kode
      t.date :dat
      t.time :tim
      t.string :adres
      t.integer :car
      t.time :beg
      t.time :en
      t.string :place_end
      t.integer :cost
      t.string :priznak
      t.string :memo
      t.string :predvar
      t.integer :working
      t.integer :uvedomlen
      t.integer :vip

      t.timestamps null: false
    end
  end
end
