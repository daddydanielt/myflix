require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "valid personal info and validcredit card", { vcr: true } do
      let(:stripe_token_options) { {card_number: 4242424242424242, exp_month: 12 ,exp_year: 2020, cvc: 123} }
      let(:user_params) { Fabricate.attributes_for(:user) }
      let(:user) { User.new( user_params ) }
  
      context "without invitation_token" do
        let(:sign_up_params) { {invitation_token: nil, stripeToken: create_stripe_card_token(stripe_token_options).id } }
        before do
          result = UserSignup.new(user, sign_up_params).sign_up
        end
        after { ActionMailer::Base.deliveries.clear }
        it_behaves_like "email sending after successfully sing up"
        it "create the user" do
          expect(User.first.email).to eq(user_params[:email])
          expect(User.first.full_name).to eq(user_params[:full_name])
          expect(User.first.authenticate(user_params[:password])).to eq(User.first)
        end
      end

      context "with invitation_token" do
        let(:mary) { Fabricate(:user) }
        let(:invitation) { Fabricate(:invitation, inviter_id: mary.id ) }
        let(:sign_up_params) { {invitation_token: invitation.token, stripeToken: create_stripe_card_token(stripe_token_options).id } }
        before do
          result = UserSignup.new(user, sign_up_params).sign_up
        end
        after { ActionMailer::Base.deliveries.clear }
        it "follow the inviter" do
          expect(user.reload.the_users_i_following).to include(mary)
        end
        it "the inviter follow the user" do
          expect(mary.the_users_i_following).to include(user)
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
  end #End describe "#sign_up"

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