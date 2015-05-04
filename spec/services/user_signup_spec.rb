require 'spec_helper'

describe UserSignup do
  describe "#sign_up_with_subscription_plan_payment", { vcr: true } do
    context "valid personal info, valid credit card and valid subscription plan", { vcr: true } do
      let(:stripe_token_options) { {card_number: 4242424242424242, exp_month: 12 ,exp_year: 2020, cvc: 123} }
      let(:user_params) { Fabricate.attributes_for(:user) }
      let(:user) { User.new( user_params ) }
      let(:subscription_plan) { "myflix_base" }
      context "without invitation_token" do
        let(:sign_up_params) { {invitation_token: nil, stripeToken: create_stripe_card_token(stripe_token_options).id } }
        before do
          result = UserSignup.new(user, sign_up_params).sign_up( subscription_plan: subscription_plan)
        end
        after { ActionMailer::Base.deliveries.clear }
        it_behaves_like "send email after successfully sing up"
        it "create the user" do
          #result = UserSignup.new(user, sign_up_params).sign_up( subscription_plan: subscription_plan)
          expect(User.count).to eq(1)
          expect(User.first.email).to eq(user_params[:email])
          expect(User.first.full_name).to eq(user_params[:full_name])
          expect(User.first.authenticate(user_params[:password])).to eq(User.first)
        end
        it "stores the customer toke from stripe" do
          #result = UserSignup.new(user, sign_up_params).sign_up( subscription_plan: subscription_plan)
          expect(User.first.customer_token).to be_present
        end
      end
      context "with invitation_token" do
        let(:inviter) { Fabricate(:user) }
        let(:invitation) { Fabricate(:invitation, inviter_id: inviter.id ) }
        let(:sign_up_params) { {invitation_token: invitation.token, stripeToken: create_stripe_card_token(stripe_token_options).id } }
        before do
          result = UserSignup.new(user, sign_up_params).sign_up( subscription_plan: subscription_plan)
        end
        after { ActionMailer::Base.deliveries.clear }
        it_behaves_like "send email after successfully sing up"
        it "follow the inviter" do
          expect(user.reload.the_users_i_following).to include(inviter)
        end
        it "the inviter follow the user" do
          expect(inviter.the_users_i_following).to include(user)
        end
        it "expires the invitation tokn upon acceptance" do
          expect(invitation.reload.token).to be_nil
        end
      end
    end
    context "invalid subscription_plan" do
      let(:stripe_token_options) { {card_number: 4242424242424242, exp_month: 12 ,exp_year: 2020, cvc: 123} }
      let(:user_params) { Fabricate.attributes_for(:user) }
      let(:user) { User.new( user_params ) }
      let(:sign_up_params) { {invitation_token: nil, stripeToken: create_stripe_card_token(stripe_token_options).id } }
      let(:invalid_subscription_plan_1) { "invalid_subscription_plan_1" }
      let(:invalid_subscription_plan_2) { nil }
      context "invalid_subscription_plan_1" do
        before do
          result = double("result", fail?: true, error_message: "No such plan: invalid_subscription_plan")
          StripeWrapper::Customer.should_receive(:create).and_return(result)
          @result = UserSignup.new(user, sign_up_params).sign_up( subscription_plan: invalid_subscription_plan_1)
        end
        it "doesn't create a new user record" do
          expect(User.count).to eq(0)
        end
        it "doesn't send email to the user" do
          expect(ActionMailer::Base.deliveries.count).to eq(0)
          ActionMailer::Base.deliveries.should be_empty
        end
        it "doesn't charge the credit card" do
          expect(@result).to be_fail
          expect(@result.error_message).to be_present
        end
      end
      context "invalid_subscription_plan_2" do
        before do
          StripeWrapper::Customer.should_not_receive(:create)
          @result = UserSignup.new(user, sign_up_params).sign_up( subscription_plan: invalid_subscription_plan_2)
        end
        it "doesn't create a new user record" do
          expect(User.count).to eq(0)
        end
        it "doesn't send email to the user" do
          expect(ActionMailer::Base.deliveries.count).to eq(0)
          ActionMailer::Base.deliveries.should be_empty
        end
        it "doesn't charge the credit card" do
          expect(@result).to be_fail
          expect(@result.error_message).to be_present
        end
      end
    end
  end # End describe "#sign_up_with_subscription_plan_payment"

  describe "#sign_up_with_charge_payment" do
    context "valid personal info and valid credit card", { vcr: true } do
      let(:stripe_token_options) { {card_number: 4242424242424242, exp_month: 12 ,exp_year: 2020, cvc: 123} }
      let(:user_params) { Fabricate.attributes_for(:user) }
      let(:user) { User.new( user_params ) }
      context "without invitation_token" do
        let(:sign_up_params) { {invitation_token: nil, stripeToken: create_stripe_card_token(stripe_token_options).id } }
        before do
          result = UserSignup.new(user, sign_up_params).sign_up
        end
        after { ActionMailer::Base.deliveries.clear }
        it_behaves_like "send email after successfully sing up"
        it "create the user" do
          expect(User.first.email).to eq(user_params[:email])
          expect(User.first.full_name).to eq(user_params[:full_name])
          expect(User.first.authenticate(user_params[:password])).to eq(User.first)
        end
      end

      context "with invitation_token" do
        let(:inviter) { Fabricate(:user) }
        let(:invitation) { Fabricate(:invitation, inviter_id: inviter.id ) }
        let(:sign_up_params) { {invitation_token: invitation.token, stripeToken: create_stripe_card_token(stripe_token_options).id } }
        before do
          result = UserSignup.new(user, sign_up_params).sign_up
        end
        after { ActionMailer::Base.deliveries.clear }
        it_behaves_like "send email after successfully sing up"
        it "follow the inviter" do
          expect(user.reload.the_users_i_following).to include(inviter)
        end
        it "the inviter follow the user" do
          expect(inviter.the_users_i_following).to include(user)
        end
        it "expires the invitation tokn upon acceptance" do
          expect(invitation.reload.token).to be_nil
        end
      end
    end

    context "valid personal info and declined credit card", { vcr: true } do
      let(:stripe_token_options) { {card_number: 4000000000000002, exp_month: 12 ,exp_year: 2020, cvc: 123} }
      let(:user_params) { Fabricate.attributes_for(:user) }
      let(:user) { User.new( user_params ) }
      let(:sign_up_params) { {invitation_token: nil, stripeToken: create_stripe_card_token(stripe_token_options).id } }
      
      before do
        #--->
        #Message Expectations
        charge = double("charge", :fail? => true, error_message: "Your card was declined." )
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        #--->
        @result = UserSignup.new(user, sign_up_params).sign_up
      end
      after { ActionMailer::Base.deliveries.clear }

      it "doesn't create a new user record" do
        expect(User.count).to eq(0)
      end

      it "doesn't send email to the user" do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
        ActionMailer::Base.deliveries.should be_empty
      end

      it "doesn't charge the credit card" do
        expect(@result).not_to be_successfull
      end
    end

    context "invalid personal info", { vcr: true } do
      let(:stripe_token_options) { {card_number: 4242424242424242, exp_month: 12 ,exp_year: 2020, cvc: 123} }
      let(:user_params) { Fabricate.attributes_for(:user, email: nil, full_name: nil) }
      let(:user) { User.new( user_params ) }
      let(:sign_up_params) { {invitation_token: nil, stripeToken: create_stripe_card_token(stripe_token_options).id } }
      
      # let(:@user) { Fabricate.build(:user )} # without saving it to Database

      before do
        @result = UserSignup.new(user, sign_up_params).sign_up
      end
      after { ActionMailer::Base.deliveries.clear }

      it "doesn't create the user" do
        expect(User.count).to eq(0)
      end
      it "doesn't send email to the user" do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
      it "doesn't charge the credit card" do
        #verify the communication with StripeWrapper::Chare in the #Create action
        #expect(StripeWrapper::Charge).not_to receive(:charge)
        expect(@result).not_to be_successfull
      end
    end
  end #End describe "#sign_up_with_charge_payment"

  def create_stripe_card_token(options={})
    #-->
    #StripeWrapper::Charge.set_api_key
    #-->
    #Move the code to the "config/initializers/stripe.rb"
    #so we don't need to call 'set_api_key' function
    #-->
    Stripe::Token.create(
      :card => {
        :number => options[:card_number],
        :exp_month => options[:exp_month],
        :exp_year => options[:exp_year],
        :cvc => options[:cvc]
      }
    )
  end
end