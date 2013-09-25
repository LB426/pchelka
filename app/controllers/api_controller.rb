require 'remotedb.rb'

class ApiController < ApplicationController
  #before_filter :current_user?
  
  def queue
  	@user = User.authenticate(params[:login], params[:password])
  	if @user
  		queue = TaxiQueue.new
      logger.debug "queue.table = #{queue.table.nil?}"
      unless queue.table.nil?
        @num_queues = queue.num_queues
        @points = queue.points
      else
        redirect_to root_url, :notice => "Connect to REMOTEDB ERROR"
      end
    else
      flash.now.alert = "Invalid login or password"
      redirect_to root_url, :notice => "Login or password incorrect"
    end
  end
  
  def test
  	current_user?
  end

  def order
    @user = User.authenticate(params[:login], params[:password])
    if @user
      z = TaxiOrder.new
      unless z.nil?
        torder = z.order(@user.car)
        logger.debug "torder = #{torder.empty? }"
        #towns = Town.where("name like '#{simvols}%'")
        #render :json => towns, :only => [:id, :name]
        #order = {:id => 1, :name => "ssss"}
        unless torder.empty?
          res = { :error => "none", :result => torder[0] }
          render :json => res
        else
          res = { :error => "none", :result => nil }
          render :json => res, :only => [:error, :result]
        end
      else
        redirect_to root_url, :notice => "Connect to REMOTEDB ERROR"
      end
    else
      flash.now.alert = "Invalid login or password"
      redirect_to root_url, :notice => "Login or password incorrect"
    end
  end

end
