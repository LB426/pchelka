# coding: utf-8
require 'net/http'

class ApiController < ApplicationController
  protect_from_forgery :except => [ 
                                    :order_create,
                                    :order_update, 
                                    :order_refuse_priz,
                                    :push_in_queue, 
                                    :order_destroy, 
                                    :state_update, 
                                    :dispreg,
                                    :caronorder,
                                    :zvonkiupd,
                                    :smsdrivergotorder,
                                    :smsdriverarrived,
                                    :orderaddcar,
                                    :orderdelcar,
                                    :ordercomplete,
                                    :setcoord,
                                    :queue_create,
                                    :queue_exec_manual,
                                    :queue_remove_car
                                  ]
  #если раскомментировать то все параметры запросов будут писаться в таблицу log
  #before_filter :write_to_log
  
  def queue
  	@user = User.authenticate(params[:login], params[:password])
  	if @user
      if request.env["HTTP_X_FORWARDED_FOR"].nil? == true
        @user.update_attribute(:ip, request.remote_ip)
      else
        @user.update_attribute(:ip, request.env["HTTP_X_FORWARDED_FOR"])
      end     
      @regions = Defset.where("name like '%район%'").distinct
      @num_queues = @regions.size
      @points = {}
      counter = 1
      @regions.each do |region|
        regname = region.name.gsub("район","")
        @points[counter] = {'name'=>regname,'queue'=>[]}
        pqueue = PointQueue.where("point_id = ?",region.id).order("created_at ASC")
        if pqueue.size > 0
          pqueue.each do |r|
            @points[counter]['queue'] << { 'car_num' => r.car, 'car_state' => r.state }
          end
        end
        counter += 1
      end
      @max_col = 0
      for i in 1..@num_queues do
        if @points[i]['queue'].size > @max_col
          @max_col = @points[i]['queue'].size
        end
      end
    else
      res = { :error => "Login or password incorrect", :result => nil }
      render :json => res
    end
  end
  
  def test
  	current_user?
    render :layout => 'application'
  end

  def order
    @user = User.authenticate(params[:login], params[:password])
    if @user
      if request.env["HTTP_X_FORWARDED_FOR"].nil? == true
        @user.update_attribute(:ip, request.remote_ip)
      else
        @user.update_attribute(:ip, request.env["HTTP_X_FORWARDED_FOR"])
      end
      order = Zakazi.where("car = #{@user.car}")
      if order.size == 1
        res = { :error => "none",
                :result => {  
                              'adres' => order[0]['adres'],
                              'zakaz' => order[0]['zakaz'],
                              'telefon' => order[0]['telefon'],
                              'kode' => order[0]['kode'],
                              'dat' => order[0]['dat'],
                              'tim' => order[0]['tim'],
                              'car' => order[0]['car'],
                              'uvedomlen' => order[0]['uvedomlen'],
                              'memo' => order[0]['memo'],
                              'predvar' => order[0]['predvar']
                            }
              }
        render json: res
      else
        res = { :error => "order.size = #{order.size}", :result => nil }
        render :json => res, :only => [:error, :result]
      end
    else
      res = { :error => "Login or password incorrect", :result => nil }
      render :json => res
    end
    rescue Exception => e
      logger.debug "Exception in ApiController order :  #{e.message} "
      res = { :error => e.message, :result => nil }
      render :json => res
  end

  # на самом деле таблица zvonkis - это все заказы поступившие, zvonkis - потому что разраб так придумал!!!
  # zakazis - это текущие заказы которые удаляются по мере обработки, а инфа о них остаётся в zvonkis
  # также zvonkis - это лог входящих звонков. Сапёров изначально писал не диспетчерскую программу а обработчик входящих звонков!!! 
  def order_create
    res = { :error => "none", :result => nil }
    logger.debug "login: #{params[:login]} password: #{params[:password]}"
    @user = User.authenticate(params[:login], params[:password])
    if @user
      # проверяем а не назначен ли заказ водителю
      zak = Zakazi.where("car = ?", params[:car])
      if zak.size == 0
        zvonki = Zvonki.new
        zvonki.telefon = params[:telefon]
        zvonki.kode = params[:kode]
        zvonki.dat = params[:dat]
        zvonki.tim = params[:tim]
        addr = params[:adres]
        zvonki.adres = addr.force_encoding("cp1251").encode("utf-8", undef: :replace)
        priznak = params[:priznak]
        zvonki.priznak = priznak.force_encoding("cp1251").encode("utf-8", undef: :replace)
        zvonki.car = params[:car]
        zvonki.save
        order = Zakazi.new
        order.zakaz = zvonki.id
        order.telefon = zvonki.telefon
        order.kode = zvonki.kode
        order.dat = zvonki.dat
        order.tim = zvonki.tim
        order.adres = zvonki.adres
        order.priznak = zvonki.priznak
        order.car = zvonki.car
        order.save
        res = { :error => "none", :result => "Заказ назначен водителю #{order.car} успешно" }
      else
        res = { :error => "Эта машина уже на заказе, car=#{params[:car]}, id заказа: #{zak[0].id}", :result => nil }
      end
    else
      res = { :error => "Login or password incorrect", :result => nil }
    end
    render :json => res
  end

  def order_update
    @user = User.authenticate(params[:login], params[:password])
    if @user
      if request.env["HTTP_X_FORWARDED_FOR"].nil? == true
        @user.update_attribute(:ip, request.remote_ip)
      else
        @user.update_attribute(:ip, request.env["HTTP_X_FORWARDED_FOR"])
      end

      unless params[:uvedomlen].empty?
        order = Zakazi.where("car = #{@user.car}")
        if order.size == 1
          Zakazi.where("car = #{@user.car}").limit(1).update_all(uvedomlen: params[:uvedomlen])
          if params[:uvedomlen] == "2"
              @user.reducecredit
          end
          res = { :error => "none", :result => "row updated: 1" }
          render :json => res
        else
          res = { :error => "order.size == #{order.size}", :result => nil }
          render :json => res
        end
      else
        res = { :error => "params uvedomlen is empty", :result => nil }
        render :json => res
      end
      if send_ref != true
        res = { :error => "message REF send ERROR", :result => nil }
      end
    else
      res = { :error => "Login or password incorrect", :result => nil }
      render :json => res
    end
    #rescue Exception => e
    #  logger.debug "Exception in ApiController order_update : #{e.message} "
    #  res = { :error => e.message, :result => nil }
    #  render :json => res
  end

  def order_destroy
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      order = Zakazi.find_by_car(@user.car)
      abonent = Abonenty.find_by_kode(order.kode)
      if abonent
        if order.priznak == "очередная"
            abonent.balans = abonent.balans + 1
        else
          if abonent
            priz_count = Defset.find_by_name("количество призовых поездок").value
            abonent.balans = abonent.balans - priz_count.to_i + 1
          end
        end
        abonent.save
      end
      zvonok = Zvonki.find_by_id(order.zakaz)
      zvonok.adres = order.adres
      zvonok.car = order.car
      zvonok.cost = params[:sum]
      zvonok.priznak = order.priznak
      zvonok.save
      order.destroy

      # шлем сообщение обновления таблиц
      #if send_ref != true
      #  res = { :error => "message REF send ERROR", :result => nil }
      #end
      send_ref
    else
      res = { :error => "Login or password incorrect", :result => nil }
    end
    render :json => res
  end

  def order_refuse_priz
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      order = Zakazi.find_by_zakaz(params[:order_id])
      order.priznak = "очередная"
      order.save
      send_ref
    else
      res = { :error => "Login or password incorrect", :result => nil }
    end
    render :json => res
  end

  def refresh_orders
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      if request.env["HTTP_X_FORWARDED_FOR"].nil? == true
        @user.update_attribute(:ip, request.remote_ip)
      else
        @user.update_attribute(:ip, request.env["HTTP_X_FORWARDED_FOR"])
      end
      if send_ref != true
        res = { :error => "message REF send ERROR", :result => nil }
      end
    else
      res = { :error => "Login or password incorrect", :result => nil }
    end
    render :json => res
  end

  def state_update
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      if @user.group == 'dispatcher'
        unless params[:state].nil? && params[:car].nil?
          p = PointQueue.where("car = ?", params[:car])
          if p.size == 1
            p[0].update_attribute(:state, params[:state])
          else
            res = { :error => "update state in point_queue unsuccess, amount car=#{@user.car} is #{p.size}, user = #{@user.login}, #{@user.group}", :result => nil }
          end
        else
          logger.debug "state=nil or car=nil"
        end
      end
      if @user.group == 'driver'
        unless params[:state].nil? 
          p = PointQueue.where("car = ?", @user.car)
          if p.size == 1
            p[0].update_attribute(:state, params[:state])
          else
            res = { :error => "update state in point_queue unsuccess, amount car=#{@user.car} is #{p.size}, user = #{@user.login}, #{@user.group}", :result => nil }
          end
        else
          logger.debug "state=nil"
          res = { :error => "state is nil, driver = @user.login", :result => nil }
        end
      end
      # шлем сообщение обновления таблиц
      if send_ref != true
        res = { :error => "message REF send ERROR", :result => nil }
      end
    else
      res = { :error => "Login or password incorrect", :result => nil }
    end
    render :json => res
  end

  def dispreg
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      if @user.group =~ /dispatcher/
        if request.env["HTTP_X_FORWARDED_FOR"].nil? == true
          @user.update_attribute(:ip, request.remote_ip)
        else
          @user.update_attribute(:ip, request.env["HTTP_X_FORWARDED_FOR"])
        end
        res = { :error => "none", :result => 'dispatcher registration OK' }
      else
        res = { :error => "dispatcher registration ERROR. group=#{@user.group}", :result => nil }
      end
    else
      res = { :error => "dispatcher registration ERROR. Login or password incorrect", :result => nil }
    end
    render :json => res
  end


  def zvonkiupd
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      unless params[:car_id].nil?
        logger.debug "car=#{params[:car_id]}"
        car_id = params[:car_id]
        order = Zakazi.where(:car => car_id)
        if order.size == 1
          if order[0].zakaz < 0
            logger.debug "order[0]=#{order[0].zakaz}"
            #добавить в звонки строчку
            z = Zvonki.new
            z.zakaz = order[0].zakaz
            z.telefon = order[0].telefon
            z.kode = order[0].kode
            z.dat = order[0].dat
            z.tim = order[0].tim
            z.adres = order[0].adres
            z.car = car_id
            z.save
          end
          if order[0].zakaz > 0
            logger.debug "order[0]=#{order[0].zakaz}"
            # обновить в звонки строку по заказу
            z = Zvonki.where(:num => order[0].zakaz)
            if z.size == 1
              Zvonki.where(:num => order[0].zakaz).limit(1).update_all(
                zakaz: order[0].zakaz,
                telefon: order[0].telefon, 
                kode: order[0].kode, 
                dat: order[0].dat, 
                tim: order[0].tim, 
                adres: order[0].adres)
            else
              res = { :error => "amount zvonkov in table zvonki for order #{order[0].zakaz} ne ravno 1", :result => nil }
            end
          end
        else
          if order.size > 1 || order.size == 0
            res = { :error => "amount orders in table zakazi #{order.size}", :result => nil }
          end
        end
      else
        res = { :error => "order_id or car is nil", :result => nil }
      end
    else
      res = { :error => "Login or password incorrect", :result => nil }
    end
    render :json => res
  end

  # показать место куда должна прибыть машины на карте
  def goal
    res = { :error => "none", :result => nil }
    @lat = nil
    @lon = nil
    @user = User.authenticate(params[:login], params[:password])
    if @user
      order = Zakazi.where(:car => @user.car)
      if order.size == 1
        street_name = nil
        street_num = nil
        # адрес в табл zakazi должен соответствовать виду "улица номердома"
        rxp = Regexp.new('^(\D+)\ +(\d+\D?)$')
        if rxp.match(order[0].adres) != nil
          street_name = rxp.match(order[0].adres)[1]
          street_num  = rxp.match(order[0].adres)[2]
        end
        if  street_name != nil && street_num != nil
          uri = URI('http://nominatim.openstreetmap.org/search.php')
          country = "Russia"
          city = "Тихорецк"
          street = "#{street_num} #{street_name.mb_chars.downcase.to_s}"
          params = { :country => country, :city => city , :street => street, :format => "json" }
          logger.debug params
          uri.query = URI.encode_www_form(params)
          res = Net::HTTP.get_response(uri)
          if res.is_a?(Net::HTTPSuccess)
            logger.debug res.body
            res_json = JSON.parse(res.body)
            if res_json.size == 1
              o = res_json[0]
              @lat = o["lat"]
              @lon = o["lon"]
              logger.debug "lat: #{@lat}"
              logger.debug "lon: #{@lon}"
              logger.debug "display_name: #{o["display_name"]}"
              render :layout => false
            elsif res_json.size > 1
              @errortext = "Openstreetmap find result for '#{street}' more 1"
              render 'api/error'
            else
              @errortext = "Openstreetmap find result for '#{street}' = 0"
              render 'api/error'
            end
          end 
        else
          @errortext = "Street name or street num is nil in zakazi for car: #{@user.car}. street_name: #{street_name}. street_num: #{street_num}. Source string for regexp is: #{order[0].adres}"
          render 'api/error'
        end
      else
        @errortext = "Order not found. car: #{@user.car}"
        render 'api/error'
      end
    else
      #res = { :error => "Login or password incorrect", :result => nil }
      #render :json => res
      @errortext = "Login or password incorrect"
      render 'api/error'
    end
  end

  # делает запись в таблицу отслеживания местоположения
  def setcoord
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user && !params[:lat].empty? && !params[:lon].empty? 
      track = Track.new
      track.user_id = @user.id
      track.lat = params[:lat]
      track.lon = params[:lon]
      if !track.save
        res = { :error => "ERROR: write LAT LON in DB Tracks", :result => nil }
      else
        execqueue(@user)
      end
    else
      res = { :error => "ERROR: Login or password incorrect or lat lon is empty", :result => nil }
    end
    render :json => res
  end

  def alarm
    res = { :error => "none", :result => nil }
    logger.debug "ALARM: user #{params[:login]} alarm incoming time: #{Time.now}"
    alarm_string = "ALARM #{params[:login]} #{Time.now.strftime("%Y-%m-%d_%H:%M:%S")}"
    send_message(alarm_string)
    @user = User.authenticate(params[:login], params[:password])
    if @user
      @user.alarm = Time.now
      if !@user.save
        res = { :error => "ERROR: write alarm date in DataBase ", :result => nil }
      end
    else
      res = { :error => "ERROR: Login or password incorrect", :result => nil }
    end
    render :json => res
  end

  def getlastdrivercoord
    res = { :error => "none", :result => nil }
    @coordinates = Array.new
    drivers_in_queue = PointQueue.where("point_id > 0")
    if drivers_in_queue.size > 0
      drivers_in_queue.each do |diq|
        user = User.find_by_car(diq.car)
        if user
          last_coord = Track.where(:user_id => user.id).last
          if last_coord
            icon = "marker.png"
            if user.login =~ /driver/
              m = user.login.scan(/(\d{1,3})$/)
              icon = "green/#{m[0][0]}.png"
            end
            driver = { :icon => icon, :lat => last_coord.lat, :lon => last_coord.lon }
            @coordinates << driver
          end
        end
      end
    end
    drivers_on_order = Zakazi.where("car IS NOT NULL")
    if drivers_on_order.size > 0
      drivers_on_order.each do |dio|
        user = User.find_by_car(dio.car)
        if user
          last_coord = Track.where(:user_id => user.id).last
          if last_coord
            icon = "marker.png"
            if user.login =~ /driver/
              m = user.login.scan(/(\d{1,3})$/)
              icon = "red/#{m[0][0]}.png"
            end
            driver = { :icon => icon, :lat => last_coord.lat, :lon => last_coord.lon }
            @coordinates << driver
          end
        end
      end
    end
    res = @coordinates if @coordinates.size > 0
    render :json => res
  end

  def taximeter
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      taximeter = @user.settings["taximeter"]
      res = { :error => "none",
              :result =>  {  
                            'cost_km_city' => taximeter["cost_km_city"],
                            'cost_km_suburb' => taximeter["cost_km_suburb"],
                            'cost_km_intercity' => taximeter["cost_km_intercity"],
                            'cost_km_n1' => taximeter["cost_km_n1"],
                            'cost_stopping' => taximeter["cost_stopping"],
                            'cost_passenger_boarding_day' => taximeter["cost_passenger_boarding_day"],
                            'cost_passenger_boarding_night' => taximeter["cost_passenger_boarding_night"],
                            'cost_passenger_pre_boarding_day' => taximeter["cost_passenger_pre_boarding_day"],
                            'cost_passenger_pre_boarding_night' => taximeter["cost_passenger_pre_boarding_night"]
                          }
            }
    else
      res = { :error => "ERROR: Login or password incorrect", :result => nil }
    end
    render :json => res
  end

  def lastposmap
    @user = User.authenticate(params[:login], params[:password])
    if @user
      @users = User.all
      @coordinates = []
      @users.each do |user|
        last_coord = Track.where(:user_id => user.id).last
        if last_coord
          icon = "marker.png"
          if user.login =~ /driver/
            m = user.login.scan(/(\d{1,3})$/)
            icon = "#{m[0][0]}.png"
          end
          if "#{last_coord.lat}" != "" && "#{last_coord.lon}" != ""
            driver = "{icon: \"#{icon}\", lat: \"#{last_coord.lat}\", lon: \"#{last_coord.lon}\"}"
            @coordinates << driver
          end
        end
      end
      @coords = @coordinates.join(",")
      logger.debug "#{@coords}"
    else
    end
    render :layout => false, :file => 'api/lastposition.html.erb'
  end

  def smsdriverarrived
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      nozak = params[:nozak]
      order = Zakazi.where(:zakaz => nozak)
      sms = Smsmsg.new
      sms.nozak = nozak
      if order.size != 0
        sms.notel = order[0].telefon
        sms.txtsms = "Машина #{@user.cardesc} такси Пчёлка прибыла на ваш заказ"
        sms.sent = 0
        if !sms.save
          res = { :error => "ERROR: write sms date in DB ", :result => nil }
        end
      else
        res = { :error => "ERROR: zakaz not found #{nozak}", :result => nil }
      end
    else
      res = { :error => "ERROR: Login or password incorrect", :result => nil }
    end
    render :json => res
  end

  def smsdrivergotorder
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      nozak = params[:nozak]
      order = Zakazi.where(:zakaz => nozak)
      if order.size != 0
        sms = Smsmsg.new
        sms.nozak = nozak
        sms.notel = order[0].telefon
        sms.txtsms = "Машина #{@user.cardesc} такси Пчёлка выехала на ваш заказ"
        sms.sent = 0
        if !sms.save
          res = { :error => "ERROR: write sms date in DB ", :result => nil }
        end
      else
        res = { :error => "ERROR: zakaz not found #{nozak}", :result => nil }
      end
    else
      res = { :error => "ERROR: Login or password incorrect", :result => nil }
    end
    render :json => res
  end

#########################################################################################

  # получить список заказов
  def orders
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      #order = Zakazi.all.order(zakaz: :desc)
      order = Zakazi.where("car = :car OR car IS NULL", car: @user.car).order(zakaz: :desc)
      if order.size > 0
        #res = { :error => "none", :result => order }
        res = order
      else
        res = { :error => "ERROR: zakazi not found", :result => nil }
      end
    else
      res = { :error => "ERROR: Login or password incorrect", :result => nil }
    end
    render :json => res, content_type: "application/json"
  end
  
  # поставить машину на заказ
  def orderaddcar
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      unless params[:order_id].nil?
        #o = Zakazi.where("(zakaz = #{params[:order_id]}) AND ((car IS NULL) OR (car = #{@user.car}))").limit(1).update_all(car: @user.car, uvedomlen: 2)
        #order = Zakazi.where("(zakaz = ?) AND ((car IS NULL) OR (car = ?))", params[:order_id], @user.car)
        order = Zakazi.where("car = ?", @user.car)
        if order.size == 1
          res = { :error => "error", :result => "this car #{@user.car} alredy on order #{order[0].id}"}
        elsif order.size == 0
          neworder = Zakazi.find_by_zakaz(params[:order_id])
          neworder.car = @user.car
          neworder.uvedomlen = 2
          neworder.save
          res = { :error => "none", :result => "car #{@user.car} set on order: #{params[:order_id]}" }
        elsif order.size > 1
          res = { :error => "BIG ERROR!!!", :result => "BIG ERROR!!! found #{order.size} orders for order_id: #{params[:order_id]}" }
        end
        send_ref
      else
        res = { :error => "order_id is nil", :result => nil }
      end
    else
      res = { :error => "Login or password incorrect", :result => nil }
    end
    render :json => res
  end

  # снять себя с заказа
  def orderdelcar
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      unless params[:order_id].nil? && params[:car].nil?
        logger.debug "order_id=#{params[:order_id]} , car=#{params[:car]}"
        Zakazi.where("zakaz = #{params[:order_id]}").limit(1).update_all(car: nil, uvedomlen: 3)
        send_ref
      else
        res = { :error => "order_id or car is nil", :result => nil }
      end
    else
      res = { :error => "Login or password incorrect", :result => nil }
    end
    render :json => res
  end

  # отработка нажатия на кнопку расчёт закончен
  def ordercomplete
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      unless params[:order_id].nil? && params[:cost].nil?
        logger.debug "order_id=#{params[:order_id]} , cost=#{params[:cost]}"
        @order = Zakazi.where("zakaz = ? AND car = ?", params[:order_id], @user.car)
        if @order.size == 1
          @order.delete_all
          # поставить машину в очередь для заранее определённого региона
          execqueue(@user)
          send_ref
        else
          res = { :error => "order not found", :result => nil }
        end
      else
        res = { :error => "order_id or car is nil", :result => nil }
      end
    else
      res = { :error => "Login or password incorrect", :result => nil }
    end
    render :json => res
  end

  # получить список районов с координатами
  def regions
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      defsets = Defset.where("name like 'район%'")
      if defsets.size > 0
        arr = Array.new
        defsets.each do |ds|
          arr << { id: ds.id, name: ds.name }
        end
        res = arr
      else
        res = { :error => "ERROR: defsets not found", :result => nil }
      end
    else
      res = { :error => "Login or password incorrect", :result => nil }
    end
    render :json => res
  end

  # поставить машину в очередь вручную, из андроид приложения
  def queue_create
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      execqueue(@user, params[:region_id])
      send_ref
    else
      res = { :error => "Login or password incorrect", :result => nil }
    end
    render :json => res    
  end

  # установить признак ручной обработки очереди в настройках пользователя
  def queue_exec_manual
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      if params[:mpinq] == "1"
        @user.mpinq = true
        @user.save
      else
        @user.mpinq = false
        @user.save
      end
    else
      res = { :error => "Login or password incorrect", :result => nil }
    end
    render :json => res    
  end

  # удалить машину из очереди
  def queue_remove_car
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      remove_from_queue(@user)
      send_ref
    else
      res = { :error => "Login or password incorrect", :result => nil }
    end
    render :json => res    
  end

  def routetoclient
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      @order = Zakazi.where("car = ?", @user.car).limit(1)
      addr = "#{@order[0].adres} тихорецк"
      uri = URI("http://nominatim.openstreetmap.org/search.php")
      country = "Russia"
      city = "Тихорецк"
      street = "#{@order[0].adres}"
      params = { :country => country, :city => city , :street => street,
                 :format => "json", :addressdetails => 1 }
      uri.query = URI.encode_www_form(params)
      resp = Net::HTTP.get_response(uri)
      if resp.is_a?(Net::HTTPSuccess)
        # logger.debug resp.body
        res_json = JSON.parse(resp.body)
        if res_json.size >= 1
          o = res_json[0]
          lat_end = o["lat"]
          lon_end = o["lon"]
          last_coord = Track.where(:user_id => @user.id).last
          lat_beg = last_coord.lat
          lon_beg = last_coord.lon
          uri = URI("https://graphhopper.com/api/1/route?" +
                    "point=#{lat_beg},#{lon_beg}&" + "point=#{lat_end},#{lon_end}&" +
                    "type=json&" +
                    #"debug=true&" +
                    "vehicle=car&locale=en&points_encoded=true&key=4dc134dc-6c96-49e6-a232-84d878f3abcf")
          #logger.debug "query: #{uri}"
          resp = Net::HTTP.get_response(uri)
          #logger.debug "resp code: #{resp.code}, resp.code.class: #{resp.code.class}"
          #logger.debug "resp body: #{resp.body}"
          body = resp.body.force_encoding("UTF-8")
          res_json = JSON.parse(body)
          #logger.debug "res json size: #{res_json.size}, class: #{res_json.class}, body: #{resp.body}"
          if resp.code == '200'
            paths = res_json["paths"]
            points = paths[0]["points"]
            #logger.debug "points: #{points}"
            res = { :error => "none", :result => { "route_geometry" => points }}
          else
            res = { :error => "router.project-osrm.org status non 200 ", :result => nil }
          end
        else
          res = { :error => "nominatim find result for '#{street}' = 0", :result => nil }
        end
      else
        res = { :error => "Response error", :result => nil }
      end
    else
      res = { :error => "Login or password incorrect", :result => nil }
    end
    render :json => res

    #rescue Exception => e
    #  logger.debug "Exception in ApiController order_update : #{e.message} "
    #  res = { :error => "EXCEPTION: " + e.message, :result => nil }
    #  render :json => res
    
  end
  
private

  def send_ref
    send_message
  end

  def send_message( message = "REF" )
    res = true
    dispatchers = User.where(group: 'dispatcher')
    dispatchers.each do |disp|
      logger.debug "disp.ip = #{disp.ip}"
      unless disp.ip.nil? || disp.ip.empty?
        begin
          $s = TCPSocket.open(disp.ip, 6004)
          $s.puts message
        rescue Exception => e
          logger.debug "Exception in ApiController refresh_orders : #{e.message} "
          res = false
        ensure
          $s.close unless $s.nil?
        end
      else
        logger.debug "disp.ip is empty or nil"
        res = false
      end
    end
    return res
  end

  # обработка очереди
  def execqueue(user, region_id = nil)
    # если не в очереди и не на заказе то поставь в очередь
    if !inqueue?(user) && !onorder?(user)
      logger.debug "машина НЕ в очереди и НЕ на заказе"
      if user.mpinq == true # в БД 1
        logger.debug "ручное помещение в очередь"
        pushin_to_region_queue(user,region_id) if region_id != nil
      else
        logger.debug "автоматическое помещение в очередь используя последние координаты"
        pushin_to_region_queue_use_real_coord(user)
      end
    end
    # если в очереди и не на заказе
    if inqueue?(user) && !onorder?(user)
      logger.debug "машина в очереди и НЕ на заказе"
      if user.mpinq == true # в БД 1, ruchnaya ochered
        logger.debug "ручное помещение в очередь"
        pushin_to_region_queue(user,region_id) if region_id != nil
      else
        # avtomaticheskaya ochered
        # v etom sluchae vsegda snavitsia v konets ocheredi
        #logger.debug "автоматическое помещение в очередь используя последние координаты"
        #remove_from_queue(user)
        #pushin_to_region_queue_use_real_coord(user)
      end
    else     
      logger.debug "машина и в очереди и на заказе"
    end
    # если на заказе то удалить из очереди
    if onorder?(user)
      logger.debug "машина на заказе"
      remove_from_queue(user)
    end
  end
  
  # проверяет машина в очереди или нет
  def inqueue?(user)
    res = true
    p = PointQueue.where(:car => user.car).count
    res = false if p == 0
    return res
  end

  # проверяет машина на заказе или нет
  def onorder?(user)
    res = true
    oc = Zakazi.where("car = ?", user.car).count
    res = false if oc == 0
    return res
  end

  # помещаем машину в очередь в зависимости от региона, если не попала ни в один регион то идентификатор региона nil 
  def pushin_to_region_queue_use_real_coord(user)
    lastcarpos = Track.where("user_id = ?",user.id).last
    point = GeoRuby::SimpleFeatures::Point.from_x_y(lastcarpos.lon, lastcarpos.lat)
    @regions = Defset.where("name like '%район%'").distinct
    ishit = false
    @regions.each do |region|
      if region.name != "район вне зоны"
        targetregion = GeoRuby::SimpleFeatures::Polygon.from_coordinates([region.value])
        if targetregion.contains_point?(point)
          PointQueue.create(point_id: region.id, car: user.car, state: 1)
          ishit = true
          logger.debug "попал в регион: #{region.name}"
          break
        end
      end
    end
    if ishit == false
      # если не попал ни в один из заранее настроенных регионов
      outofregion = Defset.find_by_name('район вне зоны')
      PointQueue.create(point_id: outofregion.id, car: user.car, state: 1)
      logger.debug "попал в регион: #{region.name}"
    end
    
  end

  def pushin_to_region_queue(user, region_id)
    region = Defset.where("id = ? AND name like '%район%'", region_id)
    if region.size == 1
      PointQueue.create(point_id: region_id, car: user.car, state: 1)
    else
      logger.debug "ERROR: region with id: #{region_id} not found"
    end
  end
  
  def remove_from_queue(user)
    logger.debug "удалить из очереди"
    PointQueue.where(:car => user.car).destroy_all
  end

end
