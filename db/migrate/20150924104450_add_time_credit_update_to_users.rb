class AddTimeCreditUpdateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tcredup, :datetime
  end
end
