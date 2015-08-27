require 'net/http'

class ApiController < ApplicationController
  protect_from_forgery :except => [ 
                                    :order_update, 
                                    :push_in_queue, 
                                    :order_destroy, 
                                    :state_update, 
                                    :dispreg,
                                    :caronorder,
                                    :zvonkiupd,
                                    :smsdrivergotorder,
                                    :smsdriverarrived
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
       
      @points ={
          1 => { 'name' => 'на заказе', 'queue' => [] },
          2 => { 'name' => 'Черёмушки', 'queue' => [] },
          3 => { 'name' => 'Элеватор', 'queue' => [] },
          4 => { 'name' => 'Глобус', 'queue' => [] },
          5 => { 'name' => 'Рынок', 'queue' => [] },
          6 => { 'name' => 'Магнолия', 'queue' => [] },
          7 => { 'name' => 'Пентагон', 'queue' => [] },
          8 => { 'name' => 'Военный', 'queue' => [] },
          9 => { 'name' => 'Та сторона', 'queue' => [] },
          10 => { 'name' => 'Парковый', 'queue' => [] }
      }

      @num_queues = @points.size
      table = PointQueue.where("car > 0")
      @points.each_key do |k|
        pqueue = PointQueue.where("point_id = ?",k).order("created_at ASC")
        if pqueue.size != 0
          pqueue.each do |r|
            @points[k]['queue'] << { 'car_num' => r['car'], 'car_state' => r['state'] }
          end
        else
        end
      end
      @max_col = 0
      for i in 2..@num_queues do
        if @points[i]['queue'].size > @max_col
          @max_col = @points[i]['queue'].size
        end
      end

    else
      res = { :error => "Login or password incorrect", :result => nil }
      render :json => res
    end

    rescue Exception => e
      logger.debug "Exception in ApiController queue: #{e.message} "
      res = { :error => e.message, :result => nil }
      render :json => res
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
                              'memo' => order[0]['memo']
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
      if params[:order_id].nil?
        order = Zakazi.where(:car => @user.car)
        if order.size == 1
          zvonok = Zvonki.where(:num => order[0].zakaz)
          if zvonok.size == 1
            Zvonki.where(:num => order[0].zakaz).limit(1).update_all(
              telefon: order[0].telefon, 
              kode: order[0].kode, 
              dat: order[0].dat, 
              tim: order[0].tim, 
              adres: order[0].adres,
              car: order[0].car,
              beg: order[0].beg,
              en: order[0].en,
              cost: order[0].cost,
              priznak: order[0].priznak )
          end
          if zvonok.size == 0
            z = Zvonki.new
            z.telefon = order[0].telefon
            z.kode = order[0].kode
            z.dat = order[0].dat
            z.tim = order[0].tim
            z.adres = order[0].adres
            z.car = @user.car
            z.beg = order[0].beg
            z.en = order[0].en
            z.cost = order[0].cost
            z.priznak = order[0].priznak
            z.save
          end
          Zakazi.where(:car => @user.car).delete_all
        else
          if order.size > 1
            Zakazi.where(:zakaz => order[0].zakaz).delete_all
            res = { :error => "amount orders in table zakazi #{order.size}", :result => nil }
          end
        end
      else
        Zakazi.where(:zakaz => params[:order_id]).delete_all
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

  def push_in_queue
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      if request.env["HTTP_X_FORWARDED_FOR"].nil? == true
        @user.update_attribute(:ip, request.remote_ip)
      else
        @user.update_attribute(:ip, request.env["HTTP_X_FORWARDED_FOR"])
      end
      p = PointQueue.where(:car => @user.car)
      if p.size == 1
        unless params[:point_id].nil? && params[:state].nil?
          p[0].destroy
          p2 = PointQueue.new
          p2.point_id = params[:point_id]
          p2.car = @user.car
          p2.state = params[:state]
          if p2.save
            # шлем сообщение обновления таблиц
            if send_ref != true
              res = { :error => "message REF send ERROR", :result => nil }
            end
          else
            res = { :error => "write in DB error", :result => nil }
          end
        else
          logger.debug "ERROR-> point_id or state is empty. point_id=#{params[:point_id]} state=params[:state]"
          res = {:error => "ERROR-> point_id or state is empty", :result => nil}
        end
      else
				logger.debug "ERROR-> amount car on point: #{p.size} for user: #{@user.login} and car: #{@user.car}"
        res = { :error => "ERROR-> amount car on point != 1, p.size=#{p.size}", :result => nil }
      end
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

  def caronorder
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      unless params[:order_id].nil? && params[:car].nil?
        logger.debug "order_id=#{params[:order_id]} , car=#{params[:car]}"
      else
        res = { :error => "order_id or car is nil", :result => nil }
      end
    else
      res = { :error => "Login or password incorrect", :result => nil }
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

  def setcoord
    res = { :error => "none", :result => nil }
    @user = User.authenticate(params[:login], params[:password])
    if @user
      lat = params[:lat]
      lon = params[:lon]
      track = Track.new
      track.user_id = @user.id
      track.lat = lat
      track.lon = lon
      if !track.save
        res = { :error => "ERROR: write LAT LON in DB ", :result => nil }
      end
    else
      res = { :error => "ERROR: Login or password incorrect", :result => nil }
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
    drivers_in_queue = PointQueue.where("point_id > 0")
    if drivers_in_queue
      @coordinates = []
      drivers_in_queue.each do |diq|
        user = User.find_by_car(diq.car)
        last_coord = Track.where(:user_id => user.id).last
        if last_coord
          icon = "marker.png"
          if user.login =~ /driver/
            m = user.login.scan(/(\d{1,3})$/)
            icon = "#{m[0][0]}.png"
          end
          driver = { :icon => icon, :lat => last_coord.lat, :lon => last_coord.lon }
          @coordinates << driver
        end
      end
      res = @coordinates unless @coordinates.size < 1
    else
      res = { :error => "ERROR: no drivers with car>0 in point_queues. api getlastdrivercoord.", :result => nil }
    end
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
        sms.txtsms = "Водитель такси Пчёлка прибыл на ваш заказ номер #{nozak}"
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
        sms.txtsms = "Водитель такси Пчёлка выехал на ваш заказ номер #{nozak}"
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

end
