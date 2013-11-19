class ChangeT1Trigger < ActiveRecord::Migration
def up
  	execute <<-SQL1
  		DROP TRIGGER IF EXISTS t1 ;
    SQL1

    execute <<-SQL2
  		CREATE TRIGGER t1 AFTER INSERT ON changeqcars FOR EACH ROW
			BEGIN
				DECLARE i, ca, r1, r2, s, cnt2, co1, co2 INT;
				DECLARE done INT DEFAULT 0;
			  DECLARE zak1, car1, cos1, cntzak INT;
			  DECLARE tel1,kod1, adr1,pri1 CHAR(25);
			  DECLARE dat1 DATE;
			  DECLARE tim1, beg1, en1 TIME;
				DECLARE cur1 CURSOR FOR SELECT id, car, row, state FROM changeqcars;
				DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
				OPEN cur1;
				REPEAT
				FETCH cur1 INTO i, ca, r2, s;
			  SELECT zakaz,telefon, kode, dat,tim, adres, car, beg, en, cost, priznak INTO zak1, tel1,    kod1, dat1,tim1,adr1, car1, beg1, en1, cos1, pri1 from zakazi WHERE car=ca;
				SELECT count(*) INTO cntzak FROM zakazi WHERE car=ca;
				IF cntzak>0 THEN
			  	SELECT count(*) INTO cntzak FROM zvonki WHERE num=zak1;
			 		IF cntzak>0 THEN
			 			UPDATE zvonki SET telefon=tel1, kode=kod1, dat=dat1,tim=tim1, adres=adr1, car=car1, beg=beg1, en=en1, cost=cos1, priznak=pri1  WHERE num=zak1;
			 		ELSE
			 			INSERT INTO zvonki (telefon, kode, dat,tim,adres,car,beg, en,cost, priznak)VALUES(tel1, kod1, dat1, tim1,adr1, car1, beg1, en1, cos1, pri1);
					END IF;
				END IF;
				UPDATE point_queues SET point_id=r2, state=s, updated_at=now() WHERE car=ca;
				UNTIL done END REPEAT;
				CLOSE cur1;
			END
    SQL2
  end

  def down
  	execute <<-SQL1
  		DROP TRIGGER IF EXISTS t1 ;
  	SQL1

		execute <<-SQL2
  		CREATE TRIGGER t1 AFTER INSERT ON changeqcars FOR EACH ROW
			BEGIN
				DECLARE i, ca, r1, r2, s, cnt2, co1, co2 INT;
				DECLARE done INT DEFAULT 0;
			  DECLARE zak1, car1, cos1, cntzak INT;
			  DECLARE tel1,kod1, adr1,pri1 CHAR(25);
			  DECLARE dat1 DATE;
			  DECLARE tim1, beg1, en1 TIME;
				DECLARE cur1 CURSOR FOR SELECT id, car, row, state FROM changeqcars;
				DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
				OPEN cur1;
				REPEAT
				FETCH cur1 INTO i, ca, r2, s;
			  SELECT zakaz,telefon, kode, dat,tim, adres, car, beg, en, cost, priznak INTO zak1, tel1,    kod1, dat1,tim1,adr1, car1, beg1, en1, cos1, pri1 from zakazi WHERE car=ca;
				SELECT count(*) INTO cntzak FROM zakazi WHERE car=ca;
				IF cntzak>0 THEN
			  	SELECT count(*) INTO cntzak FROM zvonki WHERE num=zak1;
			 		IF cntzak>0 THEN
			 			UPDATE zvonki SET telefon=tel1, kode=kod1, dat=dat1,tim=tim1, adres=adr1, car=car1, beg=beg1, en=en1, cost=cos1, priznak=pri1  WHERE num=zak1;
			 		ELSE
			 			INSERT INTO zvonki (telefon, kode, dat,tim,adres,car,beg, en,cost, priznak)VALUES(tel1, kod1, dat1, tim1,adr1, car1, beg1, en1, cos1, pri1);
					END IF;
				END IF;
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
				UNTIL done END REPEAT;
				CLOSE cur1;
			END
    SQL2
  end
end
