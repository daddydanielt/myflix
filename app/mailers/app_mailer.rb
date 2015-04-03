class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user #@user instance variable is used in email's view template
    mail to: user.email, from: 'info@myflix.com', subjet: "Welcome to MyFlix"
  end
  def send_forget_password_email(email)
    @user = User.where(email: email).last
    mail to: email, from: 'info@myflix.com', subject: "Reset your password."
  end
end