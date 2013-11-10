namespace :users do
  desc "Test alphanumeric string"
  task :seed => :environment do
    @mom = User.create(:real_number => '4699513041')
    @michael = User.where(:real_number => 9723104741).first
    @n1 = Number.create(:user => @mom, :number => '111111111')
    Number.create(:user => @mom, :number => '222222222')
    @n2 = Number.where(:user_id => @michael.id).first
    @c = Conversation.create(:first_number => @n1, :second_number => @n2)
    Message.create(:conversation => @c, :number => @n1, :message => 'hey son!', :message_type => 0)
  end

  desc "Test alphanumeric string"
  task :f => :environment do
    @user = User.where(:real_number => "9723104741").first
    @numbers = Number.where(:user_id => @user.id)
    @numbers
    final_json = Array.new
    final_json << @numbers.map do |num|
      @conversations = Conversation.where("first_number_id = ? OR second_number_id = ?", num.number, num.number)
      json = {:number => num.number, :region => num.region, :postal_code => num.postal_code, :conversations => @conversations.as_json}
      puts json
      json
    end
    puts final_json
  end

  desc "Test alphanumeric string"
  task :c_seed => :environment do
    @mom = User.create(:real_number => '4699513041')
    @n1 = Number.create(:user => @mom, :number => '9376925749')
    @michael = User.where(:real_number => '9723104741').first
    @n2 = Number.where(:user_id => @michael.id).first
    @c = Conversation.create(:first_number => @n1, :second_number => @n2)
    Message.create(:conversation => @c, :number => @n1, :message => 'hey son!', :message_type => 0)
    Message.create(:conversation => @c, :number => @n2, :message => 'sup mom...', :message_type => 0)
  end
end









