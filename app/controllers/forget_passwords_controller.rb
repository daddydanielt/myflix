class ForgetPasswordsController < ApplicationController
  def new
  end
  def create
    email = params[:email]
    if email.empty?
      flash[:error] = "Pleas fill the email filed!"
      redirect_to forget_password_path
    elsif User.where(email: email).empty?
      flash[:error] = "This email doesn't exist."
      redirect_to forget_password_path
    else
      AppMailer.send_forget_password_email(email).deliver
      render :confirm_password_reset
    end
  end
end