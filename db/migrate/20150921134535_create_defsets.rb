class CreateDefsets < ActiveRecord::Migration
  def change
    create_table :defsets do |t|
      t.string :name
      t.text :value

      t.timestamps null: false
    end
  end
end
