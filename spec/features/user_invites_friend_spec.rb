require 'spec_helper'

feature 'User invites friend' do
  scenario 'successfully invites friend and invitaion is accepted', {js:true, vcr:true} do
    mary = Fabricate(:user)
    user_sign_in(mary)
    invite_a_friend
    user_sign_out
    friend_accpets_invitation_and_completes_the_registration
    sleep 2 #slow down.
    friend_signs_in
    friend_should_follow_inviter(mary.full_name)
    #user_sign_in(mary)
    #inviter_should_follow_friend("Bob Tseng")
    ##capybara-email
    clear_email
end

  def invite_a_friend
    visit new_invitation_path
    #click_link "Invite friends"
    fill_in "Friend's Name", with: "Bob Tseng"
    fill_in "Friend's Email Address", with: "bob_tseng@test.com"
    fill_in "Invitation Message", with: Faker::Lorem.paragraph(2)
    click_button "Send Invitation"
  end

  def friend_accpets_invitation_and_completes_the_registration
    #capybara-email
    open_email "bob_tseng@test.com"
    current_email.click_link "Accept this invitation to join MyFlix"
    fill_in "Password", with: "bbb"
    fill_in "Full Name", with: "Bob Tseng"
    fill_in "Card Number", with: "4242424242424242"
    fill_in "CVC", with: "123"
    select "March",from: "date_month"
    select "2016",from: "date_year"
    click_button "Pay with card"
  end

  def friend_signs_in
    fill_in "Password", with: "bbb"
    fill_in "Email Address", with: "bob_tseng@test.com"
    click_button "Sign IN"
  end

  def friend_should_follow_inviter(inviter_name)
    click_link "People"
    expect(page).to have_content(inviter_name)
  end

  def inviter_should_follow_friend(friend_name)
    click_link "People"
    expect(page).to have_content(friend_name)
  end
end