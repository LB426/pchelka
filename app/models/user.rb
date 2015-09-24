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
    if self.settings["creditpol"]["method"] == "one_per_24_hours"
      logger.debug "reduce one_per_24_hours"
      logger.debug "#{self.tcredup}"
      self.monetary_credit = compute_monetary_credit
      self.save
    end
    if self.settings["creditpol"]["method"] == "one_per_1_order"
      logger.debug "reduce one_per_1_order"
      self.monetary_credit = compute_monetary_credit
      self.save
    end
  end

  # увеличить кредит - в момент когда счёт пополняется
  def increasecredit(quantity = 0)
    self.monetary_credit += quantity
    self.save
  end

  def setcredit(quantity = 0)
    self.monetary_credit = quantity
    self.tcredup = Time.now
    self.save
  end

  def compute_monetary_credit
    new_monetary_credit = self.monetary_credit - self.settings["creditpol"]["cost"].to_i
    if new_monetary_credit < 0
      new_monetary_credit = 0
    end
    new_monetary_credit
  end

end
