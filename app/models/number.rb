class Number < ActiveRecord::Base

  belongs_to :user
  attr_accessible :number, :user, :region, :postal_code

end

