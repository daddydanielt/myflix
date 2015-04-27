require 'spec_helper.rb'

feature 'visitor registers with the credit card payment' do
  context "success" do
    #scenario 'valid credit card number', {vcr:true, js:true, driver: :selenium} do
    scenario 'valid credit card number', {vcr:true, js:true} do
      visit register_path
      register_and_pay_with_credit_card(number: "4242424242424242", cvc:123, exp_month:"May", exp_year:2016)
      expect(page).to have_content("Successfully register.")
    end
  end

  context "issues of credit card", {vcr:true, js:true} do
    scenario 'invalid credit card number'do
      visit register_path
      register_and_pay_with_credit_card(number: "4242424242424241", cvc:123, exp_month:"May", exp_year:2016)
      expect(page).to have_content("Your card number is incorrect.")
    end

    scenario 'declined credit card' do
      visit register_path
      register_and_pay_with_credit_card(number: "4000000000000002", cvc:123, exp_month:"May", exp_year:2016)
      expect(page).to have_content("declined")
    end
  end

  def register_and_pay_with_credit_card(options={})
      fill_in "Email Address", with: "mary@test.com"
      fill_in "Password", with: "mmm"
      fill_in "Full Name", with: "Mary Wang"
      fill_in "Card Number", with: options[:number]
      fill_in "CVC", with: options[:cvc]
      select options[:exp_month], from: "date_month"
      select options[:exp_year], from: "date_year"
      #
      click_button "Pay with card"
    end
end