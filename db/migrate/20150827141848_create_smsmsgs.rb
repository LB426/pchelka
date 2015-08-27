class CreateSmsmsgs < ActiveRecord::Migration
  def change
    create_table :smsmsgs do |t|
      t.integer :nozak
      t.string :notel
      t.string :txtsms
      t.integer :sent

      t.timestamps null: false
    end
  end
end
