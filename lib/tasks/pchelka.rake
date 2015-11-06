namespace :pchelka do
  desc "Decrease credit for regular driver last 24 hour"
  task decregdrv24h: :environment do
    users = User.where("users.group = ?", "driver")
    if users.size > 0
      users.each do |user|
        mc1 = user.monetary_credit
        user.reducecredit
        if mc1 != user.monetary_credit
          Ledger.create(origin: "таймер", recipient: user.login, amount: user.monetary_credit, operation: "снятие средств со счёта 1 раз в 24 часа", when: Time.now)
        end
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
