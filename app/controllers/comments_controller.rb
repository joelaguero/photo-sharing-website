class CommentsController < ApplicationController
  	def new
  		# Pull in ID and find photo
	  	@id = params[:id]
	  	@photo = Photo.find(@id)

		# Specify to post errors to html & to use _header partial
		@user = User.new
		if session["user_id"] == -1 then
			return
		else
			@current_user = User.find(session["user_id"])
		end
	end

	def create
		# Pull in ID and find photo
		@id = params[:id]
		@photo = Photo.find(@id)

		#Specify to post errors to HTML
		@user = User.new

		# Check if user is logged in
		if session["user_id"] == -1 then
			@user.errors.add(:base, "You must be logged in to post a comment.")
	        render :action => "new", :id => @id

        # Create a comment
		else
			@current_user = User.find(session["user_id"])
		  	@comment = Comment.create
		  	@comment.photo_id = @id
		  	@comment.user_id = @current_user.id
		  	@comment.date_time = DateTime.now
		  	@comment.comment = params[:new_comment]

		  	# Indicate successfully saved comment
		  	if @comment.save 
		  		flash[:notice] = "Comment successfully created!"
		  		redirect_to :controller => 'comments', :action => 'new', :id => @id
	         	return 

         	# Display error if comment is empty
			else
				@user.errors.add(:base, "You cannot create an empty comment.")
		  		render :action => "new", :id => @id 
	        end
		end
	end

	# Helper method to find owner of photo to display return link
	def photo_owner_lookup(user_id)
		@photo_owner = User.find(user_id)
		return @photo_owner.first_name
	end
    helper_method :photo_owner_lookup

    # Allows for display of thumbnail picture in header on all pages
    def getUserPhoto(user_id)
        @photo = Photo.where(:user_id => user_id).first
        if @photo == nil then return "http://www.dataiq.com.mx/wp-content/uploads/2013/03/Icon-user.png" end
        return string = "/images/#{@photo.file_name}"
    end
    helper_method :getUserPhoto
end
