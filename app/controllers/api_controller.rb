require 'remotedb.rb'
require 'remotedb2.rb'

class ApiController < ApplicationController
  protect_from_forgery except: :order_update
  
  def queue
  	@user = User.authenticate(params[:login], params[:password])
  	if @user
      @points = TaxiDB.get_cqueue
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
      logger.debug "Exception : #{e.message} "
      res = { :error => e.message, :result => nil }
      render :json => res
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
    rescue Exception => e
      logger.debug "Exception db connection :  #{e.message} "
      res = { :error => e.message, :result => nil }
      render :json => res
  end

  def order_update
    @user = User.authenticate(params[:login], params[:password])
    if @user
      unless params[:uvedomlen].empty?
        z = TaxiOrder.new
        order = z.order(@user.car)
        logger.debug "order = #{order.empty?}"
        unless order.empty?
          logger.debug "order = #{order[0]}"
          r = z.order_set_uvedomlen(@user.car, params[:uvedomlen])
          res = { :error => "none", :result => "row updated: #{r}" }
          render :json => res
        else
          res = { :error => "order for car: #{@user.car} not found", :result => nil }
          render :json => res
        end
      else
        res = { :error => "params uvedomlen is empty", :result => nil }
        render :json => res
      end
    else
      flash.now.alert = "Invalid login or password"
      redirect_to root_url, :notice => "Login or password incorrect"
    end
    rescue Exception => e
      logger.debug "Exception db connection :  #{e.message} "
      res = { :error => e.message, :result => nil }
      render :json => res
  end

end
