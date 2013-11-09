class User < ActiveRecord::Base
  attr_accessible :real_number, :validation_code, :verified
  has_many :numbers, :dependent => :destroy
end
