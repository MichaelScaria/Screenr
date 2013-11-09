class CreateTables < ActiveRecord::Migration
  def up
  	create_table :users do |t|
  		t.string :real_number
  		t.string :validation_code
  		t.boolean :verified
  		t.timestamps
  	end

  	create_table :numbers do |t|
  		t.integer :user_id
  		t.string :number
  		t.timestamps
  	end

  	create_table :conversations do |t|
  		t.integer :first_number_id
  		t.integer :second_number_id
  		t.timestamps
  	end
  	create_table :messages do |t|
  		t.integer :conversation_id
  		t.string :message
  		t.string :media_url
  		t.integer :type
  		t.integer :number_id
  		t.timestamps
  	end
  end

  def down
  end
end
