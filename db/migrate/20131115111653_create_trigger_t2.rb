class CreateTriggerT2 < ActiveRecord::Migration
  def up
  	execute <<-SQL1
  		CREATE TRIGGER t2 AFTER UPDATE ON cqueue FOR EACH ROW
  		BEGIN
  			UPDATE cqueue SET col=0 WHERE col=-1;
  		END
    SQL1
  end

  def down
  	execute <<-SQL1
  		DROP TRIGGER IF EXISTS t2 ;
    SQL1
  end
end
