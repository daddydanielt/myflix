require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
    {
  "id" => "evt_15yaHOHm1LsTwnnZVrYYmgRo",
  "created" => 1430710202,
  "livemode" => false,
  "type" => "charge.succeeded",
  "data" => {
    "object" => {
      "id" => "ch_15yaHNHm1LsTwnnZjdxkuFMI",
      "object" => "charge",
      "created" => 1430710201,
      "livemode" => false,
      "paid" => true,
      "status" => "paid",
      "amount" => 999,
      "currency" => "usd",
      "refunded" => false,
      "source" => {
        "id" => "card_15yaHMHm1LsTwnnZddS4Yifx",
        "object" => "card",
        "last4" => "4242",
        "brand" => "Visa",
        "funding" => "credit",
        "exp_month" => 12,
        "exp_year" => 2020,
        "fingerprint" => "NfoheIZ05iYLkqY4",
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
        "customer" => "cus_6Aw9Y4gVNUhJFk"
      },
      "captured" => true,
      "card" => {
        "id" => "card_15yaHMHm1LsTwnnZddS4Yifx",
        "object" => "card",
        "last4" => "4242",
        "brand" => "Visa",
        "funding" => "credit",
        "exp_month" => 12,
        "exp_year" => 2020,
        "fingerprint" => "NfoheIZ05iYLkqY4",
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
        "customer" => "cus_6Aw9Y4gVNUhJFk"
      },
      "balance_transaction" => "txn_15yaHNHm1LsTwnnZL10LcWJP",
      "failure_message" => nil,
      "failure_code" => nil,
      "amount_refunded" => 0,
      "customer" => "cus_6Aw9Y4gVNUhJFk",
      "invoice" => "in_15yaHNHm1LsTwnnZyQZnCuGm",
      "description" => nil,
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
        "url" => "/v1/charges/ch_15yaHNHm1LsTwnnZjdxkuFMI/refunds",
        "data" => []
      },
      "statement_description" => nil
    }
  },
  "object" => "event",
  "pending_webhooks" => 2,
  "request" => "iar_6Aw9qacQYwFhyJ",
  "api_version" => "2014-08-04"
}
  end
  it "creates a payment with the stripe webhook from stripe for charge succeeded", {vcr: true} do
    sydney =  Fabricate(:user, customer_token: event_data["data"]["object"]["customer"])
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end
  it "create a payment associated with the user", {vcr: true} do
    sydney =  Fabricate(:user, customer_token: event_data["data"]["object"]["customer"])
    post '/stripe_events', event_data
    expect(Payment.first.user).to eq(sydney)
  end
  it "create a payment associated with the amount", {vcr: true} do
    sydney =  Fabricate(:user, customer_token: event_data["data"]["object"]["customer"])
    post '/stripe_events', event_data
    expect(Payment.first.amount).to eq(event_data["data"]["object"]["amount"])
  end
  it "create a payment with the reference_id", {vcr: true} do
    sydney =  Fabricate(:user, customer_token: event_data["data"]["object"]["customer"])
    post '/stripe_events', event_data
    expect(Payment.first.reference_id).to eq(event_data["data"]["object"]["id"])
  end
end