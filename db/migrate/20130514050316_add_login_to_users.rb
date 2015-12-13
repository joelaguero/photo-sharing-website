class AddLoginToUsers < ActiveRecord::Migration
    def change
	    add_column :users, :login, :string
	    User.reset_column_information
	    User.all.each do |x|
	    	x.update_attribute :login, x.last_name.downcase
	    end
    end
end
