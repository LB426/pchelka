class ApiController < ApplicationController
  protect_from_forgery :except => [ :order_update, 
                                    :push_in_queue, 
                                    :order_destroy, 
                                    :state_update, 
                                    :dispreg,
                                    :caronorder,
                                    :zvonkiupd ]
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

  	  @points =	{
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
          ########################################################################
          # для старой версии андроидного приложения
          # unless params[:row].nil? 
          #   p2.point_id = params[:row]
          # end
          # unless params['delzak'].nil?
          #   Zakazi.where(:car => @user.car).delete_all if params['delzak'] == '1'
          # end
          ########################################################################
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
        res = { :error => "ERROR-> amount car on point != 1", :result => nil }
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

private
  def send_ref
    res = true
    dispatchers = User.where(group: 'dispatcher')
    dispatchers.each do |disp|
      logger.debug "disp.ip = #{disp.ip}"
      unless disp.ip.nil? || disp.ip.empty?
        begin
          $s = TCPSocket.open(disp.ip, 6004)
          $s.puts "REF"
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
