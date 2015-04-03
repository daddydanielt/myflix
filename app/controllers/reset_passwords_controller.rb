class ResetPasswordsController < ApplicationController
  def show
    token = params[:id]
    @user = User.find_by(token: token)
    unless @user
      flash[:notice] = "Your reset password link is invalid, please reapply."
      redirect_to invalid_token_path
    end
  end

  def create
    new_password = params[:new_password]
    token = params[:token]
    user = User.find_by(token: token)
    if user
      user.password = new_password
      user.generate_token
      user.save
      flash[:notice] ="Passowrd has been sucessfully changeed. Plesas sign in with your new password."
      redirect_to signin_path
    else
      flash[:warning] = "Your reset password link is invalid, please reapply."
      redirect_to invalid_token_path
    end

  end
end