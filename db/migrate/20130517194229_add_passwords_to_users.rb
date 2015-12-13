class AddPasswordsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :password_digest, :string
  	add_column :users, :salt, :string

    User.reset_column_information
    User.all.each do |x|
    	x.update_attribute :salt, Random.rand(10000).to_s
		x.update_attribute :password_digest, Digest::SHA1.hexdigest("password#{x.salt}")
    end
  end
end
