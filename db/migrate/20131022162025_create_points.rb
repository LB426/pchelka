class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.string :name

      t.timestamps
    end
  end
end
