class UserController < ApplicationController
  before_filter :current_user_admin?
  
  def index
  end

  def showall
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(login: params[:login], password: params[:password])
      flash.now[:notice] = "Данные пользователя изменены"
    else
      flash.now[:error] = "Ошибка - данные пользователя изменить не удалось"
    end
    render :action => "edit"
  end

  def settings_taximeter
    @user = User.find(params[:id])
  end

  def update_settings_taximeter
    @user = User.find(params[:id])
    render :action => "settings_taximeter"
  end

end
