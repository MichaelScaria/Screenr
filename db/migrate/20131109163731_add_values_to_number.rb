class AddValuesToNumber < ActiveRecord::Migration
  def change
  	add_column :numbers, :region, :string
  	add_column :numbers, :postal_code, :string
  end
end
