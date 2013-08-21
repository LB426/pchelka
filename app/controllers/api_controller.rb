class ApiController < ApplicationController
  #before_filter :current_user?
  
  def queue
  	user = User.authenticate(params[:login], params[:password])
  	if user
  		#data = {
  		#					:err => 'no',
  		#					:res => [
			#	  								{:did=>1, :qn=>3, :ln=>"дом быта"},
			#	              		{:did=>2, :qn=>31, :ln=>"фонтан"}
			#	              	]
    	#			 }
    	#render :json => data, :only => [ :err, :res, :did, :qn, :ln ]
    #else
    	#data = { :err => 'autherror' }
    	#render :json => data, :only => [ :err ]
    	@data = [
    						{'name' => 'магнолия', 'queue' => [1,3,5] },
    						{'name' => 'рынок', 'queue' => [2,4,6] },
    						{'name' => 'та сторона', 'queue' => [8,9,10] }
    					]
      @q = Queue.new

    end
    render :layout => false
  end
  
  def test
  	current_user?
  end

end
