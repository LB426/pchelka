require 'mysql2'

module TaxiDB

	def TaxiDB.get_cqueue
		# номера точек и их названия
		points =	{
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
		# количество точек - стоянок такси							
		num_queues = points.size
		# получаем таблицу из БД
		client = Mysql2::Client.new(:host => "127.0.0.1", :port => 20027, :username => "dba", :password => "sql", :database => 'taxi')
		table = client.query("select * from cqueue where row != 0 order by row asc")
		# формируем массив с номерами очередей
		rows = []
		table.each	do |r|
			rows << r['row']
		end
		rows.uniq!
		rows.each do |q|
			queue_places = []
			table.each	do |r|
				if r['row'] == q
					queue_places << r['col']
				end
			end
			queue_places.sort!
			Rails.logger.debug "---------------------------"
			Rails.logger.debug queue_places

			queue_places.each do |p|
				table.each do |r|
					if r['row'] == q && r['col'] == p
						points[q]['queue'] << { 'car_num' => r['car'], 'car_state' => r['state'] }
					end
				end
			end
		end
		Rails.logger.debug "---------------------------"
		Rails.logger.debug points
		return points

		rescue Exception => e
			Rails.logger.debug "Exception :  #{e.message} "
			raise "Remote database connection failed"
	end

end