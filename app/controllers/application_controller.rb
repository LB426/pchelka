class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user
  helper_method :current_user_admin?
  helper_method :current_user_disp?
  helper_method :current_user_driver?

private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def current_user_admin?
    if current_user && current_user.group =~ /admin/
      return true 
    end
    return false
  end

  def current_user_disp?
    if current_user && current_user.group =~ /dispatcher/
      return true 
    end
    return false
  end
  
  def current_user_driver?
    if current_user && current_user.group =~ /driver/
      return true 
    end
    return false
  end

  def write_to_log
    logrec = Log.new
    if request.env["HTTP_X_FORWARDED_FOR"].nil? == true
      @ip = request.remote_ip
    else
      @ip = request.env["HTTP_X_FORWARDED_FOR"]
    end
    logrec.ip = @ip
    unless params[:login].nil? && params[:password].nil?
      @user = User.authenticate(params[:login], params[:password])
      if @user
        logrec.user = @user.login
      else
        logrec.user = "acess denied, user not found in users"
      end
    else
      if current_user
        logrec.user = current_user.login
      else
        logrec.user = "acess denied, not current_user"
      end
    end
    logrec.parameters = params
    logrec.save
    #logger.debug "#{@ip} #{params}"
  end

end
