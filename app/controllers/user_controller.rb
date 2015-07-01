class UserController < ApplicationController
  before_filter :current_user_admin?
  
  def index
  end

  def showall
    @users = User.all
  end
end
