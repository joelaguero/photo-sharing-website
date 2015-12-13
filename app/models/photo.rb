class Photo < ActiveRecord::Base
  attr_protected 

  belongs_to :user
  has_many :comments
end
