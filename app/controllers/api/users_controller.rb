require 'twilio-ruby'
class Api::UsersController < Api::ApiController

  def signup

	if params[:signup_number]
		# put your own credentials here
		account_sid = 'AC3642c0f457f22cc9d01db129adcc9694'
		auth_token = 'd9fc262df548d8a6b96d5535f1dbe7de'

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
  			:from => '8173859564',
  			:to => "#{params[:signup_number]}",
  			:body => "Hey there! Welcome to Screenr, your verification code is #{code}, enter this number into the app."
		)
	else
		json = {:error => 'invalid'}
	end
	
  	render :json => json
  end
end