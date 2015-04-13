class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user #@user instance variable is used in email's view template
    puts "email-to: #{@user.email} <#{@user.full_name}>"
    puts "from : MyFlix <info@myflix.com>"
    mail to: "#{@user.email} <#{@user.full_name}>", from: 'MyFlix <info@myflix.com>', subjet: "Welcome to MyFlix"
  end
  def send_forget_password_email(email)
    @user = User.where(email: email).last
    mail to: "#{@user.email} <#{@user.full_name}>", from: 'MyFlix <info@myflix.com>', subject: "Reset your password."
  end
  def send_invitation_email(invitation)
    @invitation = invitation
    mail to: "#{@invitation.recipient_email} <#{@invitation.recipient_name}>", from: "#{@invitation.inviter.full_name} <#{@invitation.inviter.email}>", subject: "Invitaion to register an MyFlix member today."
  end
end