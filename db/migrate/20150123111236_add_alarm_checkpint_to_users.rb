class AddAlarmCheckpintToUsers < ActiveRecord::Migration
  def change
    add_column :users, :alarm, :datetime
  end
end
