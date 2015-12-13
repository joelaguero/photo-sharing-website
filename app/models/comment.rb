class Comment < ActiveRecord::Base
  	attr_protected 

	belongs_to :user
	belongs_to :photo

	validates :comment, :presence => true
end
