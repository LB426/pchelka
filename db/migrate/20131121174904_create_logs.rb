class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :user
      t.string :ip
      t.text :parameters
      t.timestamps
    end
  end
end
