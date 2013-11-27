class ApiController < ApplicationController
  protect_from_forgery :except => [ :order_update, :push_in_queue, :order_destroy, :state_update ]
  before_filter :write_to_log
  
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

=begin
      if params[:row] == '-1'
        #изменить состояние
        unless params[:state].nil? || params[:state].empty?
          Cqueue.where("car = #{@user.car}").limit(1).update_all(state: params[:state])
          logger.debug "params[:row]=#{params[:row]}"
        end
      else
        pq = Changeqcar.new
        pq.row = params[:row]
        pq.car = @user.car
        pq.state = params[:state]
        if pq.save
          pq.destroy
          unless params['delzak'].nil? || params['delzak'].empty?
    				Zakazi.where(:car => @user.car).delete_all if params['delzak'] == '1'
          end
        else
          res = { :error => "Stay in queue error", :result => nil }
        end
      end
      if send_ref != true
        res = { :error => "message REF send ERROR", :result => nil }
      end
=end

      p = PointQueue.where(:car => @user.car)
      if p.size == 1
        p[0].destroy
        p2 = PointQueue.new
        p2.point_id = params[:point_id]
        ########################################################################
        # для старой версии андроидного приложения
        unless params[:row].nil? 
          p2.point_id = params[:row]
        end
        unless params['delzak'].nil?
          Zakazi.where(:car => @user.car).delete_all if params['delzak'] == '1'
        end
        ########################################################################
        p2.car = @user.car
        p2.state = params[:state]
        if p2.save

        else
          res = { :error => "write in DB error", :result => nil }
        end
      else
        res = { :error => "amount car on point > 1", :result => nil }
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
      unless params[:state].nil? && params[:car].nil?
        p = PointQueue.where("car = ?", params[:car])
        if p.size == 1
          p[0].update_attribute(:state, params[:state])
        else
          res = { :error => "update state in point_queue unsuccess, amount car=#{@user.car} is #{p.size}", :result => nil }
        end
      else
        logger.debug "state=nil or car=nil"
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
