require 'spec_helper'


describe StripeWrapper do
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
          expect(stripe_wrapper.fail?).not_to be_true
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
      #--->
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