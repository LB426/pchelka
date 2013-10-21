class AddGroupToUsers < ActiveRecord::Migration
  def change
    add_column :users, :group, :string, :default => "driver"
    add_column :users, :ip, :string
  end
end
