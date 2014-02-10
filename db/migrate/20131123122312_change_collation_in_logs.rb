class ChangeCollationInLogs < ActiveRecord::Migration
  def change
  	execute <<-SQL
  		ALTER TABLE logs CHARACTER SET = utf8 COLLATE = utf8_general_ci ;
    SQL
  end
end
