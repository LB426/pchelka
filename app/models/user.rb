class User < ActiveRecord::Base
  serialize :settings

  def self.authenticate(login, password)
    user = find_by_login(login)
    if user && user.password == password
      user
    else
      nil
    end
  end

  # уменьшить кредит - при отработке заказа или посуточно
  def reducecredit
    new_monetary_credit = 0
    if self.settings["creditpol"]["method"] == "one_per_24_hours"
      unless self.tcredup.nil?
        # проверяем сколько прошло времени с момента когда на счёт поступили средства
        td = Time.now - self.tcredup
        @defset = Defset.find_by_name("время снятия средств со счёта для регулярного водителя")
        time = @defset.value.to_i
        if td > time.hour
          new_monetary_credit = compute_monetary_credit
        end
      end
    end
    if self.settings["creditpol"]["method"] == "one_per_1_order"
      new_monetary_credit = compute_monetary_credit
    end
    if new_monetary_credit < self.monetary_credit
      self.monetary_credit = new_monetary_credit
      self.save
    end
  end

  def compute_monetary_credit
    new_monetary_credit = self.monetary_credit - self.settings["creditpol"]["cost"].to_i
    if new_monetary_credit < 0
      new_monetary_credit = self.monetary_credit
    end
    new_monetary_credit
  end

  # пополнить счёт на quantity
  def increasecredit(quantity = 0)
    setcredit(self.monetary_credit + quantity)
  end
  
  # установить счёт в quantity
  def setcredit(quantity = 0)
    self.monetary_credit = quantity
    self.tcredup = Time.now
    self.save
  end

end
