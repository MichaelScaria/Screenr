class User < ActiveRecord::Base
  attr_accessible :real_number, :validation_code, :verified

end
