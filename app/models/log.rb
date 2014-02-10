class Log < ActiveRecord::Base
  serialize :parameters, Hash
end
