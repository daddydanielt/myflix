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

  def new_with_invitation_token
    
    @invitation = Invitation.find_by(token: params[:token])
    if @invitation
      @user = User.new(email: @invitation.recipient_email)
      render :new
    else
      redirect_to invalid_token_path
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      #--->
      #invitation_token = params[:invitation_token]
      #if invitation_token
      #  invitation = Invitation.find_by(token: invitation_token)
      #  @user.follow(invitation.inviter)
      #  invitation.inviter.follow(@user)
      #  invitation.update(token: nil)
      #end
      #--->
      handle_invitaion
      #--->
      
      #AppMailer.send_welcome_email(@user).deliver
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

  def handle_invitaion
    invitation_token = params[:invitation_token]
    if invitation_token
      invitation = Invitation.find_by(token: invitation_token)
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update(token: nil)
    end
  end
end