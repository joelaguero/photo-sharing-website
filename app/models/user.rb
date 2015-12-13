class User < ActiveRecord::Base
  attr_protected 

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :login, :presence => {:message => "-- You must enter a login name."}, :uniqueness => {:message => "-- Sorry, this login already exists."}

  has_many :photos
  has_many :comments

  def password
  	password_digest
  end

  def password=(password)
  	self.salt = Random.rand(10000).to_s
  	self.password_digest = Digest::SHA1.hexdigest("#{password}#{self.salt}")
  end

end
