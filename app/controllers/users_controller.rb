class UsersController < ApplicationController

  def front
  end

  def new
    @user =  User.new    
  end

  def create
    @user = User.new(user_params) 
    if @user.save
      flash[:notice] = "Successfully register."
    else
      render :new
    end
  end

  private
  def user_params
    #strong parameters
    params.require(:user).permit(:email, :password, :full_name)
    #params[:user].slice(:email,:password)
  end

end