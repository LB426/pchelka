class RemoteDB < ActiveRecord::Base
  self.abstract_class = true
  establish_connection("remotedb")
end

class TaxiQueue < RemoteDB 
	self.table_name = 'cqueue'
	attr_accessor :num_queues, :table
	attr_reader :points, :queues

	def initialize
		# количество точек - стоянок такси
		#@num_queues = 10
		# номера точек и их названия
		@points =	{
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
		@num_queues	 = @points.size
		# получаем таблицу из БД
		query = "select * from cqueue where row != 0 order by row asc"
		@table = connection.select_all(query) #select_all is important!
		# формируем массив с номерами очередей
		rows = []
		@table.each	do |r|
			rows << r['row']
		end
		@queues = rows.uniq
		# машины по очередя
		@queues.each do |q|
			queue_places = []
			@table.each	do |r|
				if r['row'] == q
					queue_places << r['col']
				end
			end
			queue_places.sort!
			logger.debug "---------------------------"
			logger.debug queue_places

			queue_places.each do |p|
				@table.each do |r|
					if r['row'] == q && r['col'] == p
						@points[q]['queue'] << { 'car_num' => r['car'], 'car_state' => r['state'] }
					end
				end
			end
		end
		logger.debug "---------------------------"
		logger.debug @points

	end

end