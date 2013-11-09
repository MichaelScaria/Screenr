class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :number
  attr_accessible :conversation, :number, :message, :media_url, :type

  def as_json(options={})
    options ||= {}
    json = {
      :id => id,
      :number=> number,
      :message_type => message_type
    }
    json[:message] = message if message
    json[:media_url] = media_url if media_url

    json
  end 
end