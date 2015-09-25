class CreateLedgers < ActiveRecord::Migration
  def change
    create_table :ledgers, id: false do |t|
      t.string :origin, :null => false
      t.string :recipient, :null => false
      t.integer :amount, :null => false
      t.string :operation, :null => false
      t.datetime :when, :null => false
    end
  end
end
