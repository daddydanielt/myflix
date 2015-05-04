require 'spec_helper'

describe "deactivate user on charing failed", {vcr: true} do
  let(:event_data) do
  {
    "id" => "evt_15yZX9Hm1LsTwnnZznC1xDZB",
    "created" => 1430707335,
    "livemode" => false,
    "type" => "charge.failed",
    "data" => {
      "object" => {
        "id" => "ch_15yZX8Hm1LsTwnnZP8p6mnRR",
        "object" => "charge",
        "created" => 1430707334,
        "livemode" => false,
        "paid" => false,
        "status" => "failed",
        "amount" => 999,
        "currency" => "usd",
        "refunded" => false,
        "source" => {
          "id" => "card_15yZVyHm1LsTwnnZp6dDfPha",
          "object" => "card",
          "last4" => "0341",
          "brand" => "Visa",
          "funding" => "credit",
          "exp_month" => 5,
          "exp_year" => 2017,
          "fingerprint" => "hSdDiLlDMKgGgVqd",
          "country" => "US",
          "name" => nil,
          "address_line1" => nil,
          "address_line2" => nil,
          "address_city" => nil,
          "address_state" => nil,
          "address_zip" => nil,
          "address_country" => nil,
          "cvc_check" => "pass",
          "address_line1_check" => nil,
          "address_zip_check" => nil,
          "dynamic_last4" => nil,
          "metadata" => {},
          "customer" => "cus_6AvKHwE9z0BJB4"
        },
        "captured" => false,
        "card" => {
          "id" => "card_15yZVyHm1LsTwnnZp6dDfPha",
          "object" => "card",
          "last4" => "0341",
          "brand" => "Visa",
          "funding" => "credit",
          "exp_month" => 5,
          "exp_year" => 2017,
          "fingerprint" => "hSdDiLlDMKgGgVqd",
          "country" => "US",
          "name" => nil,
          "address_line1" => nil,
          "address_line2" => nil,
          "address_city" => nil,
          "address_state" => nil,
          "address_zip" => nil,
          "address_country" => nil,
          "cvc_check" => "pass",
          "address_line1_check" => nil,
          "address_zip_check" => nil,
          "dynamic_last4" => nil,
          "metadata" => {},
          "customer" => "cus_6AvKHwE9z0BJB4"
        },
        "balance_transaction" => nil,
        "failure_message" => "Your card was declined.",
        "failure_code" => "card_declined",
        "amount_refunded" => 0,
        "customer" => "cus_6AvKHwE9z0BJB4",
        "invoice" => nil,
        "description" => "",
        "dispute" => nil,
        "metadata" => {},
        "statement_descriptor" => nil,
        "fraud_details" => {},
        "receipt_email" => nil,
        "receipt_number" => nil,
        "shipping" => nil,
        "application_fee" => nil,
        "refunds" => {
          "object" => "list",
          "total_count" => 0,
          "has_more" => false,
          "url" => "/v1/charges/ch_15yZX8Hm1LsTwnnZP8p6mnRR/refunds",
          "data" => []
        },
        "statement_description" => nil
      }
    },
    "object" => "event",
    "pending_webhooks" => 2,
    "request" => "iar_6AvNU5nf6Mp3AZ",
    "api_version" => "2014-08-04"
  }
  end
  it "deactivates the user with the webhook data from stripe for a charge failed" do
    sydney =  Fabricate(:user, customer_token: event_data["data"]["object"]["customer"])
    post '/stripe_events', event_data
    expect(Payment.count).to eq(0)
    expect(sydney.reload).not_to be_active
  end
end