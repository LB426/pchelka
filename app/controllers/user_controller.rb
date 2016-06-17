class UserController < ApplicationController
  before_filter :current_user_admin?
  
  def index
  end

  def showall
   #@users = User.where("'group' = ?", "driver")
   @users = User.where("users.group = ? OR users.group = ? OR users.group = ?", "driver", "bombila", "unavailable")
  end

  def new
    @user = User.new
    @password = pwgen(10)
  end

  def create
    @user = User.new
    @user.login = params[:login]
    @user.password = params[:password]
    @user.car = params[:car]
    @user.cardesc = params[:cardesc]
    @user.group = params[:group]
    @user.monetary_unit = params[:monetary_unit]
    @user.monetary_credit = params[:monetary_credit]
    @user.settings = { "taximeter"=> nil, "creditpol" => nil }
    @user.settings["taximeter"] = Defset.find_by_name("taximeter").value
    @user.settings["creditpol"] = Defset.find_by_name("кредитная политика постоянный водитель").value
    @user.mpinq = 1
    @user.save
    redirect_to user_showall_path
  end

  def edit
    @user = User.find(params[:id])
    unless @user.group =~ /admin/
      @groups = [["постоянный водитель","driver"],
                 ["бомбила","bombila"],
                 ["недоступен","unavailable"]]
    else
      redirect_to root_url
      flash[:notice] = "ты админ! не редактируй себя!".html_safe
    end
  end

  def update
    @user = User.find(params[:id])
    unless @user.group =~ /admin/
      if @user.update(
                        login: params[:login], 
                        password: params[:password],
                        car: params[:car],
                        cardesc: params[:cardesc],
                        group: params[:group],
                        monetary_unit: params[:monetary_unit],
                      )
        flash[:notice] = "Данные пользователя <strong>#{@user.login}</strong> изменены успешено".html_safe
      else
        flash[:error] = 'Данные пользователя <strong>#{@user.login}</strong> НЕ изменены'.html_safe
      end
    else
      flash[:notice] = "ты админ! не редактируй себя!".html_safe
    end
    redirect_to user_showall_path
  end

  def destroy
    @user = User.find(params[:id])
    if current_user.id == @user.id 
      redirect_to user_showall_path, notice: "Попытка удалить АДМИНА!!! и самого себя - это ПЛОХО!!! АЛАРМ!!! ЧТО ТЫ ДЕЛАЕШЬ!!!" 
    else
      @user.destroy
      redirect_to user_showall_path, notice: "Удалён пользователь #{@user.login}" 
    end
  end

  def settings_taximeter
    @user = User.find(params[:id])
    if @user.settings.nil?
      taximeter = { 
                    "cost_km_city" => 0,
                    "cost_km_suburb" => 0,
                    "cost_km_intercity" => 0,
                    "cost_km_n1" => 0,
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
    @cost_km_n1 = @taximeter["cost_km_n1"]
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
                  "cost_km_n1" => params[:cost_km_n1],
                  "cost_stopping" => params[:cost_stopping],
                  "cost_passenger_boarding_day" => params[:cost_passenger_boarding_day],
                  "cost_passenger_boarding_night" => params[:cost_passenger_boarding_night],
                  "cost_passenger_pre_boarding_day" => params[:cost_passenger_pre_boarding_day],
                  "cost_passenger_pre_boarding_night" => params[:cost_passenger_pre_boarding_night]
                }
    if @user.settings.nil?
      @user.settings = { "taximeter" => taximeter }
    else
      @user.settings["taximeter"] = taximeter
    end
    if @user.save
      #flash.now[:notice] = "Настройки таксометра запомнены"
      flash[:notice] = "Настройки таксометра запомнены"
    else
      flash.now[:notice] = "Настройки таксометра запомнить не удалось"
    end
    #render :action => "settings_taximeter"
    redirect_to user_show_settings_taximeter_path(@user)
  end

  def mass_assign_taximeret_reg_driver
    @user = current_user
    @taximeter = Defset.find_by_name("taximeter").value
    @cost_km_city = @taximeter["cost_km_city"]
    @cost_km_suburb = @taximeter["cost_km_suburb"]
    @cost_km_intercity = @taximeter["cost_km_intercity"]
    @cost_km_n1 = @taximeter["cost_km_n1"]
    @cost_stopping = @taximeter["cost_stopping"]
    @cost_passenger_boarding_day = @taximeter["cost_passenger_boarding_day"]
    @cost_passenger_boarding_night = @taximeter["cost_passenger_boarding_night"]
    @cost_passenger_pre_boarding_day = @taximeter["cost_passenger_pre_boarding_day"]
    @cost_passenger_pre_boarding_night = @taximeter["cost_passenger_pre_boarding_night"]
  end

  def mass_update_settings_taximeter
    taximeter = { 
                  "cost_km_city" => params[:cost_km_city],
                  "cost_km_suburb" => params[:cost_km_suburb],
                  "cost_km_intercity" => params[:cost_km_intercity],
                  "cost_km_n1" => params[:cost_km_n1],
                  "cost_stopping" => params[:cost_stopping],
                  "cost_passenger_boarding_day" => params[:cost_passenger_boarding_day],
                  "cost_passenger_boarding_night" => params[:cost_passenger_boarding_night],
                  "cost_passenger_pre_boarding_day" => params[:cost_passenger_pre_boarding_day],
                  "cost_passenger_pre_boarding_night" => params[:cost_passenger_pre_boarding_night]
                }
    users = User.where(group: 'driver')
    if users.size > 0
      users.each do |user|
        user.settings["taximeter"] = taximeter
        user.save
      end
    end
    redirect_to user_showall_path
  end

  def edit_settings_credit_policy
    @user = User.find(params[:id])
    @method = @user.settings["creditpol"]["method"]
    @cost = @user.settings["creditpol"]["cost"]
    @methods = [["один раз за 24 часа","one_per_24_hours"],["за каждый заказ","one_per_1_order"]]
    
    rescue Exception => e
      logger.debug "Exception in UsersController edit_settings_credit_policy: #{e.message} "
      res = { :error => e.message, :result => nil }
      redirect_to user_index_path, :notice => "Кредитная политика для пользователя не установлена. #{@user.login}"
  end

  def update_settings_credit_policy
    @user = User.find(params[:id])
    creditpol = { "method" => params[:method],
                  "cost" => params[:cost] }
    @user.settings["creditpol"] = creditpol
    @user.save
    redirect_to user_showall_path, notice: "Метод расчёта для #{@user.login} обновлён"
  end

  def mass_edit_settings_credit_policy_reg_driver
    creditpol = Defset.find_by_name("кредитная политика постоянный водитель").value
    @method = creditpol["method"]
    @cost = creditpol["cost"]
    @methods = [["один раз за 24 часа","one_per_24_hours"],["за каждый заказ","one_per_1_order"]]
    @monetary_unit = Defset.find_by_name("денежная единица").value
  end

  def mass_update_settings_credit_policy
    users = User.where(group: 'driver')
    if users.size > 0
      users.each do |user|
        user.settings["creditpol"] = {"method"=>params[:method],"cost"=>params[:cost]}
        user.save
      end
    end
    redirect_to user_index_path, notice: "Кредитная политика установлена"
  end

  def mass_manualqueue
    users = User.where(group: 'driver')
    if users.size > 0
      users.each do |user|
        user.mpinq = 1
        user.save
      end
    end
    redirect_to user_index_path, notice: "Ручная постановка в очередь установлена всем водителям"
  end

  def pwgen(len = 8)
    #rand_password=('0'..'z').to_a.shuffle.first(8).join
    #chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    chars = ("a".."z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def edit_score
    @user = User.find(params[:id])
  end

  def update_score
    @user = User.find(params[:id])
    if params[:monetary_credit].empty?
      redirect_to user_showall_path, :flash => { :error => "Счёт водителя НЕ изменён, Вы не ввели количество рублей для внесения на счёт" }
    else
      if params[:monetary_credit].to_i >= 0 
        @user.increasecredit(params[:monetary_credit].to_i)
        Ledger.create(origin: current_user.login, recipient: @user.login, amount: @user.monetary_credit, operation: "пополнение", when: Time.now)
        redirect_to user_showall_path, notice: "Счёт водителя #{@user.login} изменён"
      else
        redirect_to user_showall_path, :flash => { :error => "Счёт водителя НЕ изменён, Вы ввели отрицательное количество рублей для внесения на счёт" }
      end
    end
  end

  def driver_monetary_credit_dec
    users = User.where("users.group = ?", "driver")
    if users.size > 0
      users.each do |user|
        mc1 = user.monetary_credit
        user.reducecredit
        if mc1 != user.monetary_credit
          Ledger.create(origin: current_user.login, recipient: user.login, amount: user.monetary_credit, operation: "test driver_monetary_credit_dec", when: Time.now)
        end
      end
      redirect_to user_showall_path, :flash => { :error => "Предпринята попытка массового уменьшения счёта" }
    else
      @result = "Regular driver not found\n"
      redirect_to user_showall_path, :flash => { :error => "Счёт водителя НЕ изменён для всех" }
    end
  end

end
