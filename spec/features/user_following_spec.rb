require 'spec_helper'

feature "user following" do 
  scenario "user follows and unfollow someone" do  
    mary = Fabricate(:user)
    following_user = Fabricate(:user)
    category = Fabricate(:category)    
    video = Fabricate(:video, category: category)
    review = Fabricate(:review, user: following_user, video: video)
    
    user_sign_in(mary)
        
    click_on_video_on_home_page(video)
    click_link following_user.full_name
    click_link "Follow"
    
    expect(page).to have_content(following_user.full_name)
    
    unfollow(following_user)
    expect(page).not_to have_content(following_user.full_name)
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end