class RemoteDB < ActiveRecord::Base
  self.abstract_class = true #important!
  establish_connection("remotedb")
end
