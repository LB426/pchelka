class AddIndexToLog < ActiveRecord::Migration
  def change
    add_index :logs, :user
    add_index :logs, :created_at
  end
end
