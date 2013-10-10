require 'remotedb2.rb'

class AboutController < ApplicationController
  def index
  	#q = RemoteDB2.new
  	#q.get_cqueue
  	#logger.debug q
  end

  def errors
  	logger.info "Error 404"
  	render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

end
