class ApiController < ApplicationController
  before_filter :current_user?
  
  def queue
    data = [  
              {:did=>1, :qn=>3, :ln=>"дом быта"},
              {:did=>2, :qn=>31, :ln=>"фонтан"}
            ]
    render :json => data, :only => [ :did, :qn, :ln]
  end
  
end
