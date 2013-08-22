class AddCarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :car, :integer
  end
end
