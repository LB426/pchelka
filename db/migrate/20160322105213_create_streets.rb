class CreateStreets < ActiveRecord::Migration
  def change
    create_table :streets do |t|
      t.string :street

      t.timestamps null: false
    end
  end
end
