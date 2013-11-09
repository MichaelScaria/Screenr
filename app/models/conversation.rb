class Conversation < ActiveRecord::Base
  belongs_to :first_number, class_name: "Number"
  belongs_to :second_number, class_name: "Number"
  attr_accessible :first_number, :second_number

  def as_json(options={})
    options ||= {}
    json = {
      :id => id,
      :first_number=> first_number,
      :second_number => second_number
    }
    json
  end 
end
