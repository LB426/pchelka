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
end
