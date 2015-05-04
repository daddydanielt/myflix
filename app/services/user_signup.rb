#[service object]
class UserSignup
  attr_accessor :user
  attr_reader :error_message, :status

  def initialize(user, params)
    @user = user
    @params = params
  end

  def sign_up( options = {} )
    if @user.valid?
      # Charge
      #charge = ( options.has_key? :subscription_plan ) ? handle_subscription_plan_payment(options[:subscription_plan]) : handle_charge_payment
      charge = have_subscription_plan?(options) ? handle_subscription_plan_payment(options[:subscription_plan]) : handle_charge_payment
      if charge.nil? || charge.fail?
        @error_message =  charge.nil? ? "Invalid subscription plan!" : charge.error_message
        #raise ActiveRecord::Rollback, "Credit Card Error: #{charge.error_message}"
        @status = :failed
      else
        #--->
        #@user.customer_token = charge.response.id if have_subscription_plan?(options)
        #--->
        @user.customer_token = charge.token if have_subscription_plan?(options)
        #--->
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
    return self
  end

  def successfull?
    @status == :success
  end

  def fail?
    !successfull?
  end

  private
  def have_subscription_plan?(options)
    options.has_key? :subscription_plan
  end

  def handle_invitaion
    invitation_token = @params[:invitation_token]
    if invitation_token
      invitation = Invitation.find_by(token: invitation_token)
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update(token: nil)
    end
  end

  def handle_charge_payment
    token = @params[:stripeToken]
    charge = StripeWrapper::Charge.create({ amount: 999,
                                   currency: "usd",
                                   source: token,
                                   description: "Sing up charge for #{@user.email}" })
  end
  def handle_subscription_plan_payment(subscription_plan)
    token = @params[:stripeToken]
    if subscription_plan.nil?
      nil
    else
      StripeWrapper::Customer.create({
        :plan => subscription_plan,
        :user => @user,
        :source => token
        })
    end
  end
end