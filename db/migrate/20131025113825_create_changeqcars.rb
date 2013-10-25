class CreateChangeqcars < ActiveRecord::Migration
  def change
    create_table :changeqcars do |t|
      t.integer :car
      t.integer :row
      t.integer :state

      t.timestamps
    end
  end
end
