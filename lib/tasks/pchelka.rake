namespace :pchelka do
  desc "Decrease credit for regular driver last 24 hour"
  task decregdrv24h: :environment do
    users = User.where("users.group = ?", "driver")
    if users.size > 0
      users.each do |user|
        cost = user.settings["creditpol"]["cost"].to_i
        user.monetary_credit -= cost
        user.save
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
         user.monetary_credit = 150
         user.save
      end
    end
  end
end
