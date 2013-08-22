require 'remotedb.rb'

class ApiController < ApplicationController
  #before_filter :current_user?
  
  def queue
  	@user = User.authenticate(params[:login], params[:password])
  	if @user
  		queue = TaxiQueue.new
      @num_queues = queue.num_queues
      @points = queue.points
    else
      redirect_to root_url
    end
  end
  
  def test
  	current_user?
  end

end
