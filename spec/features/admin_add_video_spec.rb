require 'spec_helper'

feature 'Admin user adds new videos' do
  scenario "Admin user adds video" do
    category = Fabricate(:category, title: "sport")
    admin_user = Fabricate(:admin)
    user_sign_in(admin_user)
    visit new_admin_video_path

    fill_in "Title", with: "video_title"
    select "sport", from: "Category"
    fill_in "Description", with: "video_description"
    attach_file "Large Cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small Cover", "spec/support/uploads/monk.jpg"
    fill_in "Video Url", with: "https://diikjwpmj92eg.cloudfront.net/uploads/week6/HW3%20watch%20video.mp4"
    click_button "Add Video"
    
    visit video_path(Video.first)
    
    expect(page).to have_selector("img[src='#{Video.last.big_cover_url}']")
    expect(page).to have_selector("a[href='#{Video.last.video_url}']")
  end
end