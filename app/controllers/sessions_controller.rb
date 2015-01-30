class SessionsController < ApplicationController

  before_action :signin_params, only: [:create]

  def new   
    @user = User.new    
  end

  def create    
    email = signin_params[:email]
    password = signin_params[:password]
    @user = User.find_by(email: email)    
    if @user && @user.authenticate(password)
      session[:user_id] = @user.id
      flash[:notice]= "Successfully Singin."
      redirect_to :root
    else
      flash[:notice] = "Permission denied."
      redirect_to signin_path
    end 
  end  

  def destroy
    if current_user
      session[:user_id]= nil
      flash[:notice] = "881. You've logged out."    
    end
    redirect_to front_path
  end

  private
  def signin_params    
    strong_parameters = params.require(:user).permit(:email, :password)    

    (notice ||= "") << (("Email Address can't be empty! <br/> ".html_safe if strong_parameters[:email].blank?) || "")
    (notice ||= "") << (("Password can't be empty! <br/> ".html_safe if strong_parameters[:password].blank?) || "")    
    flash[:notice] = notice.html_safe 

    #redirect_to signin_path unless !flash[:notice]
    redirect_to signin_path unless flash[:notice].blank?    
    return strong_parameters
  end
end