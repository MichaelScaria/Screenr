class RenameType < ActiveRecord::Migration
  def up
  	remove_column :messages, :type
  	add_column :messages, :message_type, :integer
  end

  def down
  end
end
