class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      if request.env["HTTP_X_FORWARDED_FOR"].nil? == true
        user.update_attribute(:ip, request.remote_ip)
      else
        user.update_attribute(:ip, request.env["HTTP_X_FORWARDED_FOR"])
      end
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid login or password"
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
  
end
