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
    if @user.update(
                      login: params[:login], 
                      password: params[:password],
                      car: params[:car],
                      group: params[:group],
                      monetary_unit: params[:monetary_unit],
                      monetary_credit: params[:monetary_credit]
                    )
      flash.now[:notice] = "Данные пользователя изменены"
    else
      flash.now[:error] = "Ошибка - данные пользователя изменить не удалось"
    end
    render :action => "edit"
  end

  def settings_taximeter
    @user = User.find(params[:id])
    if @user.settings.nil?
      taximeter = { 
                    "cost_km_city" => 0,
                    "cost_km_suburb" => 0,
                    "cost_km_intercity" => 0,
                    "cost_stopping" => 0,
                    "cost_passenger_boarding_day" => 0,
                    "cost_passenger_boarding_night" => 0,
                    "cost_passenger_pre_boarding_day" => 0,
                    "cost_passenger_pre_boarding_night" => 0
                  }
      @user.settings = { "taximeter" => taximeter }
      @user.save
    end
    @taximeter = @user.settings["taximeter"]
    @cost_km_city = @taximeter["cost_km_city"]
    @cost_km_suburb = @taximeter["cost_km_suburb"]
    @cost_km_intercity = @taximeter["cost_km_intercity"]
    @cost_stopping = @taximeter["cost_stopping"]
    @cost_passenger_boarding_day = @taximeter["cost_passenger_boarding_day"]
    @cost_passenger_boarding_night = @taximeter["cost_passenger_boarding_night"]
    @cost_passenger_pre_boarding_day = @taximeter["cost_passenger_pre_boarding_day"]
    @cost_passenger_pre_boarding_night = @taximeter["cost_passenger_pre_boarding_night"]
  end

  def update_settings_taximeter
    @user = User.find(params[:id])
    taximeter = { 
                  "cost_km_city" => params[:cost_km_city],
                  "cost_km_suburb" => params[:cost_km_suburb],
                  "cost_km_intercity" => params[:cost_km_intercity],
                  "cost_stopping" => params[:cost_stopping],
                  "cost_passenger_boarding_day" => params[:cost_passenger_boarding_day],
                  "cost_passenger_boarding_night" => params[:cost_passenger_boarding_night],
                  "cost_passenger_pre_boarding_day" => params[:cost_passenger_pre_boarding_day],
                  "cost_passenger_pre_boarding_night" => params[:cost_passenger_pre_boarding_night]
                }
    @user.settings = { "taximeter" => taximeter }
    if @user.save
      #flash.now[:notice] = "Настройки таксометра запомнены"
      flash[:notice] = "Настройки таксометра запомнены"
    else
      flash.now[:notice] = "Настройки таксометра запомнить не удалось"
    end
    #render :action => "settings_taximeter"
    redirect_to user_show_settings_taximeter_path(@user)
  end

end
