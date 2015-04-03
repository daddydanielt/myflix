class UsersController < ApplicationController
  before_action :require_sign_in, only:[:show]

  def show
    #binding.pry
    @user = User.find(params[:id])
    #@user = User.find(params[:id].split("-").last)
  end

  def new
    @user =  User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      AppMailer.send_welcome_email(@user).deliver
      #redirect_to signin_path
      redirect_to signin_path, flash: {notice: "Successfully register.", test: "okokkokokk"}
    else
      render :new
    end
  end

  private
  def user_params
    #strong parametersparams
    #params.require(:video_id).permit! + params.require(:user).permit(:email, :password, :full_name)
    params.require(:user).permit(:email, :password, :full_name)
    #params[:user].slice(:email,:password)
  end

end