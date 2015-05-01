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

  context "fail", {vcr:true, js:true} do
    before do
      visit register_path
    end

    context "invalid credit card info" do
      scenario 'invalid credit card number'do
        register_and_pay_with_credit_card(number: "4242424242424241", cvc:123, exp_month:"May", exp_year:2016)
        expect(page).to have_content("Your card number is incorrect.")
      end

      scenario 'declined credit card' do
        register_and_pay_with_credit_card(number: "4000000000000002", cvc:123, exp_month:"May", exp_year:2016)
        expect(page).to have_content("declined")
      end
      scenario 'empty credit card number field', {driver: :selenium} do
        register_and_pay_with_credit_card(number: "", cvc:123, exp_month:"May", exp_year:2016)
        expect(page).to have_content("This card number looks invalid.")
      end
    end

    scenario "invalid user info" do
      register_and_pay_with_credit_card(email: "", number: "4000000000000002", cvc:123, exp_month:"May", exp_year:2016)
      expect(page).to have_content("Email Address can't be blank")
    end

    scenario "both user infor and credit card info are invalid", {driver: :selenium} do
      register_and_pay_with_credit_card(email: "", password:"", full_name:"", number: "4000000000000002", cvc:123, exp_month:"May", exp_year:2016)
      expect(page).to have_content("Email Address can't be blank")
      expect(page).to have_content("Password can't be blank")
      expect(page).to have_content("minimum is 3 characters")
      expect(page).to have_content("Full Name can't be blank")
    end
  end

  def register_and_pay_with_credit_card(options={})
    fill_in "Email Address", with: options[:email] || "mary@test.com"
    fill_in "Password", with: options[:password] || "mmm"
    fill_in "Full Name", with: options[:full_name] || "Mary Wang"
    fill_in "Card Number", with: options[:number]
    fill_in "CVC", with: options[:cvc]
    select options[:exp_month], from: "date_month"
    select options[:exp_year], from: "date_year"
    #
    click_button "Pay with card"
  end
end