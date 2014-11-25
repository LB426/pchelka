class AddPrimaryKeyToPointQueue < ActiveRecord::Migration
  def up
    execute "ALTER TABLE point_queues ADD UNIQUE (car);"
  end

  def down
    execute "ALTER TABLE point_queues DROP INDEX car;"
  end
end

# было сделано во время борьбы с задвоениями водителей в таблице очередей
