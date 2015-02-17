class UsersController < ApplicationController

  def front
  end

  def new
    @user =  User.new    
  end

  def create
    @user = User.new(user_params) 
    if @user.save      
      #redirect_to signin_path
      redirect_to signin_path, flash: {notice: "Successfully register.", test: "okokkokokk"}
    else
      render :new
    end
  end

  private
  def user_params
    #strong parameters
    params.require(:video_id).permit! + params.require(:user).permit(:email, :password, :full_name)
    #params[:user].slice(:email,:password)
  end

end