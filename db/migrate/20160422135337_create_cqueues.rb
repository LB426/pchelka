class CreateCqueues < ActiveRecord::Migration
  def change
    create_table :cqueues do |t|
      t.integer :num
      t.integer :car
      t.integer :state
      t.string :mesto
      t.integer :row
      t.integer :col

      t.timestamps null: false
    end
  end
end
