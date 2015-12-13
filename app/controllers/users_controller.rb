class UsersController < ApplicationController

    def index
        @users = User.all

        # Specify to post errors to html & to use _header partial
        if session["user_id"] == -1 then
            return
        else
            @current_user = User.find(session["user_id"])
        end

    end

    def login
        @user = User.new

        # Specify to post errors to html & to use _header partial
        if session["user_id"] == nil or session["user_id"] == -1 then
            return
        else
            @current_user = User.find(session["user_id"])
        end
    end

    def post_login
        
        @user = User.new # Initialize so errors can post to html

        # Pull in parameters
        @login_attempt = params[:text_val]
        @password_attempt = params[:password]

        @current_user = User.find_by_login(@login_attempt)

        # Check if the user exists, display error if it doesn't
        if @current_user == nil then
            @user.errors.add(:base, "The login you entered does not exist.")
            render :action => "login"

        # Check if the password is correct
        elsif password_valid?(@password_attempt) then
            session["user_id"] = @current_user.id
            redirect_to :controller => 'photos', :action => 'index', :id => @current_user.id
            return

        # Display error if incorrect password
        elsif password_valid?(@password_attempt) == false then
            @user.errors.add(:base, "The password you entered is not valid.")
            @current_user = nil
            render :action => "login"
        end
             
        
    end

    # Logs user out and sets session value to unused value
    def logout
        session["user_id"] = -1
        redirect_to :action => "login"
    end

    def new
        @user = User.new
    end

    # Creates new user
    def create
        @user = User.new

        #Create new user
        if params[:register][:password] == params[:register][:password_confirm] then
            @user.first_name = params[:register][:first_name]
            @user.last_name = params[:register][:last_name]
            @user.login = params[:register][:login]
            @user.password=(params[:register][:password])
            if  @user.save 
                flash[:notice] = "Registration successful!"
                redirect_to :controller => 'users', :action => 'new'
                return 
            else
                render :action => "new"
            end
        else
            @user.errors.add(:base, "The passwords you entered do not match.")
            render :action => "new"
        end


    end

    # Compares user-entered password (+ salt and digested) with stored password_digest
    def password_valid?(password)
        @user = User.find_by_login(params[:text_val])
        if Digest::SHA1.hexdigest("#{password}#{@user.salt}") == @user.password then
            return(true)
        else
            return(false)
        end

    end

    # Retrieves user's first photo or sets generic photo for thumbnail photos
    def getUserPhoto(user_id)
        @photo = Photo.where(:user_id => user_id).first

        # Use generic user photo if user has no photo
        if @photo == nil then return "http://www.dataiq.com.mx/wp-content/uploads/2013/03/Icon-user.png" end
        
        # Use user's first photo as thumbnail photo    
        return string = "/images/#{@photo.file_name}"
    end
    helper_method :getUserPhoto

end