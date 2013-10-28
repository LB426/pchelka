class AddDispatchersToUsers < ActiveRecord::Migration
  def up
  	disp = User.new
  	disp.login = "disp1"
  	disp.password = "1234"
  	disp.car = 10001
  	disp.group = "dispatcher"
  	disp.save
  	disp = User.new
  	disp.login = "disp2"
  	disp.password = "1234"
  	disp.car = 10002
  	disp.group = "dispatcher"
  	disp.save
  end

  def down
  	dispatchers = User.where(group: 'dispatcher')
    dispatchers.each do |disp|
    	disp.destroy
    end
  end
end
