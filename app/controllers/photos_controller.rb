class PhotosController < ApplicationController
    def index
  		@id = params[:id]
  		@user = User.find(@id)
  		@photos = Photo.where(:user_id => @id)

  		



		# Specify to post errors to html & to use _header partial
  		if session["user_id"] == -1 then
            return
        else
        	@current_user = User.find(session["user_id"])
        end
    end

    def new
    	@user = User.new

		# Specify to post errors to html & to use _header partial
  		if session["user_id"] == -1 then
            return
        else
        	@current_user = User.find(session["user_id"])
        end
    end

    def create
    	# Allows errors to post to HTMl
    	@user = User.new

    	# Check if a user is logged in, throw appropriate error otherwise
    	if session["user_id"] == -1 then
			@user.errors.add(:base, "You must be logged in to upload a photo.")
	        render :action => "new"
         else
			# Define current user
			@current_user = User.find(session["user_id"])

			#Check if a file was selected
			if params[:upload] == nil then
				@user.errors.add(:base, "Please select a photo to upload.")
	         	render :controller => 'photos', :action => 'new'
	         	return
	        end

		  	#Create new photo object
		  	@photo = Photo.create
		  	@photo.user_id = @current_user.id
		  	@photo.date_time = DateTime.now
		  	@photo.file_name = params[:upload][:photo].original_filename

		  	# Store the file data
		  	name = @photo.file_name
		  	directory = "public/images"
		  	path = File.join(directory, name)
		  	File.open(path, "wb") { |x| x.write(params[:upload][:photo].read) }

		  	# Successfully saved photo notice
		  	if @photo.save then
		  		flash[:notice] = "Photo successfully uploaded!"
		  		redirect_to :controller => 'photos', :action => 'new'
	         	return 
	        end
		end
    end

    # Finds owner of the comment (used to improve project4 code,
    # to avoid calling model in view).
    def comment_owner_lookup(user_id)
		return @comment_owner = User.find(user_id)
	end
    helper_method :comment_owner_lookup

    # Allows for display of thumbnail picture in header on all pages
    def getUserPhoto(user_id)
        @photo = Photo.where(:user_id => user_id).first
        if @photo == nil then return "http://www.dataiq.com.mx/wp-content/uploads/2013/03/Icon-user.png" end
        return string = "/images/#{@photo.file_name}"
    end
    helper_method :getUserPhoto

end
