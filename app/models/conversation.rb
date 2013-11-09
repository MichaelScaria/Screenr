class Conversation < ActiveRecord::Base
  belongs_to :first_number, class_name: "Number"
  belongs_to :second_number, class_name: "Number"
  attr_accessible :first_number, :second_number

  def as_json(options={})
    options ||= {}
    json = {
      :id => id,
      :first_number=> first_number.number,
      :first_region => first_number.region,
      :first_postal_code=>first_number.postal_code,
      :second_number => second_number.number,
      :second_region => second_number.region,
      :second_postal_code=>second_number.postal_code,
    }
    json
  end 
end
