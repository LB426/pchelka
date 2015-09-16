class AddCarDescriptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cardesc, :string
  end
end
