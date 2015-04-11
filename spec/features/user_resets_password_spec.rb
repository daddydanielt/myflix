require 'spec_helper'

feature "User resets password" do
  scenario "user successfully resets the password" do
    mary = Fabricate(:user, password: 'old_password')
    
    visit signin_path
    click_link "Forget password?"
    fill_in "Email Address", with: mary.email
    click_button "Send Email"

    open_email(mary.email)
    current_email.click_link "Reset your password"

    fill_in "New Password", with: "new_password"
    click_button "Reset Password"

    fill_in "Email Address", with: mary.email
    fill_in "Password", with: "new_password"
    click_button "Sign IN"

    expect(page).to have_content("Welcome, #{mary.full_name}")

    clear_email
  end
end