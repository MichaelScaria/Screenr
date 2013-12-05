require 'twilio-ruby'
class Api::UsersController < Api::ApiController

  def signup

	if params[:signup_number]
		# put your own credentials here
		account_sid = 'AC20d859d12f3d9c0bc13214dfb2c575cf'
		auth_token = '5d0bff17823060e379cc6024361e4b23'

		# set up a client to talk to the Twilio REST API
		a = ('A'..'Z').to_a+(0..9).to_a
    	code = (1..5).collect { a[rand(a.size)] }.join
    	if User.exists?(:real_number => params[:signup_number])
    		#resend verification
    		@user = User.where(:real_number => params[:signup_number]).first
    		json ={:success => 'resent'}
    	else
    		@user = User.create(:real_number => params[:signup_number])
    		# @user.save
    		json ={:success => 'sent'}
    	end
    	@user.validation_code = code
    	@user.verified = false
    	@user.save!
		@client = Twilio::REST::Client.new account_sid, auth_token
		@client.account.messages.create(
  			:from => '2406692696',
  			:to => "#{params[:signup_number]}",
  			:body => "Hey there! Welcome to Screenr, your verification code is #{code}, enter this code into your app."
		)
	else
		json = {:error => 'invalid'}
	end
	
  	render :json => json
  end

  def verify
  	if params[:validation_code] && User.exists?(:validation_code => params[:validation_code])
  		json = {:final => 'success'}
	else
		json = {:final => 'error'}
	end
	
  	render :json => json
  end

  def area_code
  	if params[:area_code]
  		puts "AREA CODE #{params[:area_code]}"
	  	account_sid = 'AC20d859d12f3d9c0bc13214dfb2c575cf'
		auth_token = '5d0bff17823060e379cc6024361e4b23'
		@client = Twilio::REST::Client.new account_sid, auth_token
	 
		@numbers = @client.account.available_phone_numbers.get('US').local.list(:area_code => params[:area_code])
	else 
		@numbers = {}
	end
	new_array = Array.new
	new_array << @numbers.map do |num|
		{:number => num.phone_number.to_s, :region => num.region.to_s, :postal_code => num.postal_code.to_s}
	end
	puts new_array
	render :json => new_array
  end

  def initial
  	if params[:initial]
  		puts "INITIAL #{params[:initial]}"
	  	account_sid = 'AC20d859d12f3d9c0bc13214dfb2c575cf'
		auth_token = '5d0bff17823060e379cc6024361e4b23'
		@client = Twilio::REST::Client.new account_sid, auth_token
	 
		@numbers = @client.account.available_phone_numbers.get('US').local.list(:contains => "#{params[:initial]}****")
	else 
		@numbers = {}
	end
	new_array = Array.new
	new_array << @numbers.map do |num|
		{:number => num.phone_number.to_s, :region => num.region.to_s, :postal_code => num.postal_code.to_s}
	end
	puts new_array
	render :json => new_array
  end

  def state
  	if params[:state]
  		puts "STATE #{params[:state]}"
	  	account_sid = 'AC20d859d12f3d9c0bc13214dfb2c575cf'
		auth_token = '5d0bff17823060e379cc6024361e4b23'
		@client = Twilio::REST::Client.new account_sid, auth_token
	 
		@numbers = @client.account.available_phone_numbers.get('US').local.list(:in_region => params[:state])
	else 
		@numbers = {}
	end
	new_array = Array.new
	new_array << @numbers.map do |num|
		{:number => num.phone_number.to_s, :region => num.region.to_s, :postal_code => num.postal_code.to_s}
	end
	puts new_array
	render :json => new_array
  end

  def purchase
  	if params[:purchase] && params[:phone_number]
	  	account_sid = 'AC20d859d12f3d9c0bc13214dfb2c575cf'
		auth_token = '5d0bff17823060e379cc6024361e4b23'
		@client = Twilio::REST::Client.new account_sid, auth_token
	 
		@client.account.incoming_phone_numbers.create(:phone_number => params[:purchase])
		@user = User.where(:real_number => params[:phone_number]).first
		@number = Number.create(:user => @user, :number => params[:purchase], :region => params[:region], :postal_code => params[:postal_code])
		@number.save!
		json = {:final => 'success'}
	else
		json = {:final => 'error'}
	end
	render :json => json
  end

  def inbox
  	@user = User.where(:real_number => "#{params[:phone_number]}").first
  	puts "TEST#{@user}"
  	@numbers = Number.where(:user_id => @user.id)
  	final_json = Array.new
  	final_json << @numbers.map do |num|
  		@conversations = Conversation.where("first_number_id = ? OR second_number_id = ?", num.id, num.id)
  		json = {:number => num.number, :region => num.region, :postal_code => num.postal_code, :conversations => @conversations.as_json}
  		json
  	end
  	render :json => final_json
  end

  def messages
  	@conversation = Conversation.find(params[:conversation_id])
  	if @conversation
  		@messages = Message.where(:conversation_id => @conversation.id)
  		puts 'MESSAGES'
  		puts @messages
  		render :json => @messages.as_json
  	else
  		render :nothing => true
  	end

  end

  def sendx
  	account_sid = 'AC20d859d12f3d9c0bc13214dfb2c575cf'
	auth_token = '5d0bff17823060e379cc6024361e4b23'
	@client = Twilio::REST::Client.new account_sid, auth_token
	@client.account.messages.create(
		:from => "#{params[:number]}",
 	 	:to => "9723104741",
 		:body => "#{params[:message]}"
		)
	@number = Number.where(:number => "#{params[:number]}").first
	@conversation = Conversation.find(params[:conversation_id])
	Message.create(:conversation => @conversation, :number => @number, :message => "#{params[:message]}", :message_type => 0)
	@messages = Message.where(:conversation_id => @conversation.id)
	render :json => @messages.as_json
        puts 'save'
  end

  def start
  	account_sid = 'AC20d859d12f3d9c0bc13214dfb2c575cf'
	auth_token = '5d0bff17823060e379cc6024361e4b23'
	@client = Twilio::REST::Client.new account_sid, auth_token
	@client.account.messages.create(
		:from => "#{params[:number]}",
 	 	:to => "9723104741",
 		:body => "#{params[:message]}"
		)
	@number = Number.where(:number => "#{params[:number]}").first
	@conversation = Conversation.find(params[:conversation_id])
	Message.create(:conversation => @conversation, :number => @number, :message => "#{params[:message]}", :message_type => 0)
	@messages = Message.where(:conversation_id => @conversation.id)
  end

 #  def send
 #  	if params[:conversation_id] && params[:number] && params[:a_number] && params[:message]
	#   	account_sid = 'AC20d859d12f3d9c0bc13214dfb2c575cf'
	# 	auth_token = '5d0bff17823060e379cc6024361e4b23'
	# 	@client = Twilio::REST::Client.new account_sid, auth_token
	# 	@client.account.messages.create(
 #  			:from => "#{params[:number]}",
 #  			:to => "9723104741",
 #  			:body => "#{params[:message]}"
	# 	)
	# 	@number = Number.where(:number => "#{params[:number]}").first
	# 	@conversation = Conversation.find(params[:conversation_id])
	# 	Message.create(:conversation => @conversation, :number => @number, :message => "#{params[:message]}", :message_type => 0)
	# 	json = {:final => 'success'}
	# else
	# 	json = {:final => 'error'}
	# end
	# render :json => json
 #  end
end
