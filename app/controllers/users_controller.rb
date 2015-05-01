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
    result = UserSignup.new(@user, sing_up_params).sign_up
    if result.successfull?
      #flash[:success] = "Thank you for registering with MyFlix. Please sign in now."
      flash[:success] =  "Successfully register."
      redirect_to signin_path
    else
      flash[:error] = result.error_message
      render :new
    end
  end

#  def create_original_1
#    @user = User.new(user_params)
#    User.transaction do
#      if @user.save
#
#        #--->
#        #ret_msg = handle_charge
#        #if !!ret_msg.presence
#        #  flash[:error] = ret_msg
#        #  raise ActiveRecord::Rollback, "Credit Card Error: #{ret_msg}"
#        #end
#        #--->
#        charge = handle_charge_with_stripe_wrapper
#        if charge.fail?
#          flash[:error] = charge.error_message
#          raise ActiveRecord::Rollback, "Credit Card Error: #{charge.error_message}"
#        end
#        #--->
#
#        #--->
#        #invitation_token = params[:invitation_token]
#        #if invitation_token
#        #  invitation = Invitation.find_by(token: invitation_token)
#        #  @user.follow(invitation.inviter)
#        #  invitation.inviter.follow(@user)
#        #  invitation.update(token: nil)
#        #end
#        #--->
#        handle_invitaion
#        #--->
#        #AppMailer.send_welcome_email(@user).deliver
#        AppMailer.send_welcome_email(@user).deliver
#        #redirect_to signin_path, flash: {notice: "Successfully register.", test: "okokkokokk"}
#        redirect_to signin_path, flash: {notice: "Successfully register."}
#        return
#      #else
#      #  render :new
#      #  return
#      end
#    end
#    render :new
#  end

  private
  def user_params
    #strong parametersparams
    #params.require(:video_id).permit! + params.require(:user).permit(:email, :password, :full_name)
    params.require(:user).permit(:email, :password, :full_name)
    #params[:user].slice(:email,:password)
  end
  def sing_up_params
    #strong parametersparams
    #params.require(:video_id).permit! + params.require(:user).permit(:email, :password, :full_name)
    params.permit(:invitation_token, :stripeToken)
    #params[:user].slice(:email,:password)
  end
  # refactory to the UserSignup.rb
  #def handle_invitaion
  #  invitation_token = params[:invitation_token]
  #  if invitation_token
  #    invitation = Invitation.find_by(token: invitation_token)
  #    @user.follow(invitation.inviter)
  #    invitation.inviter.follow(@user)
  #    invitation.update(token: nil)
  #  end
  #end

  # refactory to the UserSignup.rb
  #def handle_charge_with_stripe_wrapper
  #  token = params[:stripeToken]
  #  StripeWrapper::Charge.create({ amount: 999,
  #                                 currency: "usd",
  #                                 source: token,
  #                                 description: "Sing up charge for #{@user.email}" })
  #end

  #def handle_charge
  #  Stripe.api_key = ENV['stripe_api_key']
  #  # Get the credit card details submitted by the form
  #  token = params[:stripeToken]
  #  # Create the charge on Stripe's servers - this will charge the user's card
  #  begin
  #    charge = Stripe::Charge.create(
  #      :amount => 999,
  #      :currency => "usd",
  #      :source => token,
  #      :description => "Sing up charge for #{@user.email}"
  #    )
  #  rescue Stripe::CardError => e
  #    return e.message
  #  end
  #end
end