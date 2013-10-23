class CreatePointQueues < ActiveRecord::Migration
  def change
    create_table :point_queues do |t|
      t.integer :point_id
      t.integer :car
      t.integer :state

      t.timestamps
    end
  end
end
