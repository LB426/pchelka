class Queue < SupportBase 
    #SupportBase not ActiveRecord is important!

    self.table_name = 'cqueue'

    def self.getall
        query = "select * from cqueue"
        tst = connection.select_all(query) #select_all is important!
        return tst[0].fetch('car')
    end
end
