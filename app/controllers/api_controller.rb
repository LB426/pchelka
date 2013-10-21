class ApiController < ApplicationController
  protect_from_forgery except: :order_update
  
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
      table = Cqueue.where("car > 0")
      rows = []
  		table.each	do |r|
  			if r != nil
  			rows << r['row']
  			end
  		end
  		rows.uniq!
  		rows.each do |q|
  			queue_places = []
  			table.each	do |r|
  				if r != nil
  				if r['row'] == q
  					queue_places << r['col']
  				end
  				end
  			end
  			queue_places.sort!
  			queue_places.each do |p|
  				table.each do |r|
  					if r != nil
  					  if r['row'] == q && r['col'] == p
    						if @points[q] != nil
    							@points[q]['queue'] << { 'car_num' => r['car'], 'car_state' => r['state'] }
    						end
    					end
  					end
  				end
  			end
  		end
      @num_queues = @points.size
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
                :result => {  'adres' => order[0]['adres'],
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
    else
      res = { :error => "Login or password incorrect", :result => nil }
      render :json => res
    end
    #rescue Exception => e
    #  logger.debug "Exception in ApiController order_update : #{e.message} "
    #  res = { :error => e.message, :result => nil }
    #  render :json => res
  end

end
