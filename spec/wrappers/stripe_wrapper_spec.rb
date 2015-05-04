require 'spec_helper'
describe StripeWrapper do

  describe StripeWrapper::Customer, {vcr: true} do
    context "valid card and valid subscription plan" do
      let(:credit_card_valid)  {{ card_number: 4242424242424242, exp_month: 12 ,exp_year: 2016, cvc: 123 }}
      let(:stripe_token) {create_stripe_card_token( credit_card_valid )}
      let(:mary) {Fabricate(:user, email: "mary_#{Faker::Code.isbn}@test.com")}
      let(:subscription_plan) {"myflix_base"}
      it "creates a customer " do
        response = StripeWrapper::Customer.create(
          :plan => subscription_plan,
          :user => mary,
          :source => stripe_token.id #note: just pass stripe_token.id
        )
        expect(response).not_to be_fail
        expect(response.fail?).to be_falsey
        expect(response.error_message).not_to be_present
      end
      it "returns token" do
        response = StripeWrapper::Customer.create(
          :plan => subscription_plan,
          :user => mary,
          :source => stripe_token.id #note: just pass stripe_token.id
        )
        response.token.should be_present
      end
    end
    context "invalid credit card issues" do
      context "credit card declined" do
        let(:subscription_plan) {"myflix_base"}
        let(:sydney) {Fabricate(:user)}
        it_behaves_like "invalid credit card issues" do
          let(:credit_card) {{card_number: 4000000000000002, exp_month: 12 ,exp_year: 2020, cvc: 123}}
          let(:stripe_token) {create_stripe_card_token( credit_card )}
        end
      end

      context "Attaching this card to a Customer object will succeed, but attemp ts to charge the customer will fail." do
        let(:subscription_plan) {"myflix_base"}
        let(:sydney) {Fabricate(:user, email: 'sydnet@test,com')}
        it_behaves_like "invalid credit card issues" do
          let(:credit_card) {{card_number: 4000000000000341, exp_month: 12 ,exp_year: 2020, cvc: 123}}
          let(:stripe_token) {create_stripe_card_token( credit_card )}
        end
      end
      #--->
      # The following testing are moved to the shared examples, "invalid credit card issues."
      # --->
      #it "doesn't create a customer" do
      #  response = StripeWrapper::Customer.create(
      #    :plan => subscription_plan,
      #    :user => sydney,
      #    :source => stripe_token.id #note: just pass stripe_token.id
      #  )
      #  expect(response).to be_fail
      #  expect(response.fail?).to be_truthy
      #end
      #it "returns a error_message" do
      #  response = StripeWrapper::Customer.create(
      #    :plan => subscription_plan,
      #    :user => sydney,
      #    :source => stripe_token.id #note: just pass stripe_token.id
      #  )
      #  expect(response.error_message).to be_present
      #end
      #it "doesn't have token value" do
      #  response = StripeWrapper::Customer.create(
      #    :plan => subscription_plan,
      #    :user => sydney,
      #    :source => stripe_token.id #note: just pass stripe_token.id
      #  )
      #  expect(response.token).not_to be_present
      #end
      #--->
    end
    context "invalid subscription plan" do
      let(:credit_card_valid) {{card_number: 4242424242424242, exp_month: 12 ,exp_year: 2020, cvc: 123}}
      let(:stripe_token) {create_stripe_card_token( credit_card_valid )}
      let(:sydney) {Fabricate(:user)}
      let(:subscription_plan) {"invalid_subscription_plan"}
      it "returns error_message" do
        response = StripeWrapper::Customer.create(
          :plan => "invalid_subscription_plan",
          :user => sydney,
          :source => stripe_token.id #note: just pass stripe_token.id
        )
        expect(response.error_message).to be_present
      end
    end
  end # End describe StripeWrapper::Customer

  describe StripeWrapper::Charge do
    describe "(testing style #1) .create", :vcr do
      let(:credit_card_valid) { {card_number: 4242424242424242, exp_month: 12 ,exp_year: 2020, cvc: 123} }
      let(:credit_card_declined) { {card_number: 4000000000000002, exp_month: 12 ,exp_year: 2020, cvc: 123} }
      let(:charge_options) {{ amount: 999,
                              currency: "usd",
                              source: stripe_token.id,
                              description: "Sing up charge user money" }}
      let(:stripe_wrapper) { StripeWrapper::Charge.create(charge_options) }
      context "success to charge", :vcr do
        let(:stripe_token) { create_stripe_card_token( credit_card_valid )}
        it "makea a successful charge" do
          stripe_wrapper = StripeWrapper::Charge.create(charge_options)
          #expect(stripe_wrpper.response.amount).to eq(charge_options[:amount])
          #expect(stripe_wrapper.response.currency).to eq(charge_options[:currency])
          expect(stripe_wrapper.fail?).to be_falsey
          expect(stripe_wrapper).not_to be_fail
        end
      end
      context "fail to charge", :vcr do
        let(:stripe_token) { create_stripe_card_token( credit_card_declined )}
        it "makes a card declined charge" do
          stripe_wrapper = StripeWrapper::Charge.create(charge_options)
          expect(stripe_wrapper).to be_fail
        end
        it "return error_message"  do
          stripe_wrapper = StripeWrapper::Charge.create(charge_options)
          expect(stripe_wrapper.error_message).to be_present
        end
      end
    end
  end # End describe StripeWrapper::Charge

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

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe "testing  style #2:"  do
      let(:stripe_token) { stripe_token = create_stripe_card_token( credit_card ) }
      context "with valid credit card", :vcr do
        let(:credit_card) { {card_number: 4242424242424242, exp_month: 12 ,exp_year: 2020, cvc: 123} }
        it " charges the card successfully" do
          charge_options = { amount: 999, currency: "usd", source: stripe_token.id, description: "Sing up charge user money" }
          stripe_wrapper = StripeWrapper::Charge.create(charge_options)
          stripe_wrapper.should_not be_fail
        end
      end
      context "with invalid credit card", :vcr do
        let(:credit_card) { {card_number: 4000000000000002, exp_month: 12 ,exp_year: 2020, cvc: 123} }
        let(:charge_options)  { {amount: 999, currency: "usd", source: stripe_token.id, description: "Sing up charge user money"} }
        let(:stripe_wrapper) { StripeWrapper::Charge.create(charge_options) }
        it "doesn't charge the card" do
          stripe_wrapper.should be_fail
        end
        it "contains an error message" do
          stripe_wrapper.error_message.should be_present
        end
      end

      def create_stripe_card_token(options={})
        StripeWrapper::Charge.set_api_key
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
  end
end