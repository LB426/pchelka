class CreateLedgers < ActiveRecord::Migration
  def change
    create_table :ledgers do |t|
      t.string :name, :null => false
      t.integer :amount, :null => false
      t.string :transaction, :null => false
      t.datetime :created_at, :null => false
    end
  end
end
