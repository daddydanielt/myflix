require 'spec_helper'

#feature 'User signs in' do
#  background do
#    User.create( username: "john", full_name: "John Doe")
#  end
#  scenario "with existing username" do
#    visit root_path
#    fill_in "username", with: "john"
#    click_button "Sign in"
#    page.should have_content "John Doe"
#  end
#end

feature 'User sings in' do
  #background do
  #  User.create( email: "test@test.com", password: "test", full_name: "Test Test")
  #end
  #scenario "with valid e-mail and password " do
  #  binding.pry
  #  visit signin_path
  #  fill_in "Email Address", with: "test@test.com"
  #  fill_in "Password", with: "test"
  #  click_button "Sign IN"
  #  page.should have_content "Successfull SignIn"
  #  page.should have_content "Test Test"
  #end
  scenario "with valid e-mail and password " do
    user = Fabricate(:user)
    user_sign_in(user)
    page.should have_content "Successfull SignIn"
    #puts "user.full_name= #{user.full_name}"
    page.should have_content user.full_name
  end

  scenario "with deactivated user" do
    user = Fabricate(:user, active: false)
    user_sign_in(user)
    
    page.should_not have_content "Successfull SignIn"
    page.should_not have_content user.full_name
    page.should have_content "Your account has been suspended, please contact customer service."

  end
end