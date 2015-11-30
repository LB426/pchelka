class AddManualPlacementInQueueToUser < ActiveRecord::Migration
  def change
    add_column :users, :mpinq, :bool
  end
end
