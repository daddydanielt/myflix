class SessionsController < ApplicationController

  before_action :signin_params, only: [:create]

  def new   
    redirect_to home_path if current_user
    @user = User.new    
  end

  def create    
    email = signin_params[:email]
    password = signin_params[:password]
    #@user = User.find_by(email: email)    
    @user = User.where(email: email).first    
    if @user && @user.authenticate(password)
      session[:user_id] = @user.id      
      redirect_to home_path, flash: {notice: "Successfull SignIn"}
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
    redirect_to root_path
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