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
        order = TaxiDB.get_order(@user.car)
        if order != nil
          res = { :error => "none", :result => order }
          render :json => res
        else
          res = { :error => "none", :result => nil }
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
      unless params[:uvedomlen].empty?
        r = TaxiDB.set_uvedomlen(@user.car, params[:uvedomlen])
        res = { :error => "none", :result => "row updated: #{r}" }
        render :json => res
      else
        res = { :error => "params uvedomlen is empty", :result => nil }
        render :json => res
      end
    else
      res = { :error => "Login or password incorrect", :result => nil }
      render :json => res
    end
    rescue Exception => e
      logger.debug "Exception in ApiController order_update : #{e.message} "
      res = { :error => e.message, :result => nil }
      render :json => res
  end

end
