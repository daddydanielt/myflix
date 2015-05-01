class UserSignup
  attr_accessor :user
  attr_reader :error_message, :status

  def initialize(user, params)
    @user = user
    @params = params
  end

  def sign_up
    if @user.valid?
      # Charge
      charge = handle_charge_with_stripe_wrapper
      if charge.fail?
        @error_message = charge.error_message
        #raise ActiveRecord::Rollback, "Credit Card Error: #{charge.error_message}"
        @status = :failed
      else
        # Register
        @user.save
        # Inviatation(follow each other)
        handle_invitaion
        # E-mail
        AppMailer.send_welcome_email(@user).deliver
        #redirect_to signin_path, flash: {notice: "Successfully register."}
        @status = :success
      end
    else
      @status = :failed
      @error_message = "Invalid user information, please check the errors."
    end
    self
  end

  def successfull?
    @status == :success
  end

  private
  def handle_invitaion
    invitation_token = @params[:invitation_token]
    if invitation_token
      invitation = Invitation.find_by(token: invitation_token)
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update(token: nil)
    end
  end

  def handle_charge_with_stripe_wrapper
    token = @params[:stripeToken]
    charge = StripeWrapper::Charge.create({ amount: 999,
                                   currency: "usd",
                                   source: token,
                                   description: "Sing up charge for #{@user.email}" })
  end
end