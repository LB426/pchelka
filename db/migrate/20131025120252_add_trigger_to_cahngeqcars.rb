class AddTriggerToCahngeqcars < ActiveRecord::Migration
  def up
  	execute <<-SQL
			CREATE TRIGGER t1 AFTER INSERT ON changeqcars FOR EACH ROW
			BEGIN
				DECLARE i, ca, r1, r2, s, cnt2, co1, co2 INT;
				DECLARE done INT DEFAULT 0;
				DECLARE cur1 CURSOR FOR SELECT id, car, row, state FROM changeqcars;
				DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
				OPEN cur1;
				REPEAT

				FETCH cur1 INTO i, ca, r2, s;
				SELECT row INTO r1 FROM cqueue WHERE car=ca;
				SELECT COUNT(col) INTO cnt2 FROM cqueue WHERE row=r2;
				SELECT col INTO co1 FROM cqueue WHERE car=ca;
				UPDATE cqueue SET col=col-1 WHERE row=r1 AND col>co1;
				UPDATE cqueue SET state=s WHERE car=ca;
				IF r1 <> r2 THEN
					UPDATE cqueue SET col=cnt2, row=r2 WHERE car=ca;
				ELSE
					UPDATE cqueue SET col=cnt2-1 WHERE car=ca;
				END IF;
				

				UNTIL done  END REPEAT;
				CLOSE cur1;
			END
    SQL
  end

  def down
  	execute <<-SQL
      DROP TRIGGER t1 ;
    SQL
  end
end
