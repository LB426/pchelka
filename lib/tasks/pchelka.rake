namespace :pchelka do
  desc "Decrease credit for regular driver last 24 hour"
  task decregdrv24h: :environment do
    users = User.where("users.group = ?", "driver")
    if users.size > 0
      users.each do |user|
        user.reducecredit
      end
    else
      puts "Regular driver not found\n"
    end
  end
  
  desc "Assign credit all drivers to 150 rub"
  task cred150rub: :environment do
    users = User.where("users.group = ?", "driver")
    if users.size > 0
      users.each do |user|
         user.setcredit(150)
      end
    end
  end
end
