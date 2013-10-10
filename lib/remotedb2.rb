require 'mysql2'

class RemoteDB2
	def get_cqueue
		client = Mysql2::Client.new(:host => "localhost", :port => 20027, :username => "dba", :password => "sql", :database => 'taxi', :encoding => 'utf8')
		res = client.query("SELECT * FROM cqueue WHERE row != 0 ORDER BY row ASC ;")
		return res
	end
end