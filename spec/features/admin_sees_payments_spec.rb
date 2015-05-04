require 'spec_helper'

feature 'admin sees payments' do
  background do
    mary = Fabricate(:user, full_name: "Mary Ann", email: "mary@test.com", admin:false)
    Fabricate(:payment, amount: 999, user: mary)
  end
  scenario "admin can see payments", {driver: :selenium} do
    admin = Fabricate(:user, admin:true)
    user_sign_in admin
    visit admin_payments_path
    expect(page).to have_content("9.99")
    expect(page).to have_content("Mary Ann")
    expect(page).to have_content("mary@test.com")
  end
  scenario "user cannot see payments", {driver: :selenium} do
    user = Fabricate(:user, admin:false)
    user_sign_in user
    visit admin_payments_path
    expect(page).not_to have_content("9.99")
    expect(page).not_to have_content("Mary Ann")
    expect(page).not_to have_content("mary@test.com")
    expect(page).to have_content("Permission denied!!")
  end
end