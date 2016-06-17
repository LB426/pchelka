class AboutController < ApplicationController
  def index
  end

  def errors
  	logger.info "Error 404"
  	render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

end
