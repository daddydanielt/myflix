#------>>
def user_sign_in(user = nil)
 user = user || Fabricate(:user, email: "test@test.com", passowrd: "test", full_name: "Test Test")
 visit signin_path
 fill_in "Email Address", with: user.email
 fill_in "Password", with: user.password
 click_button "Sign IN"
end

def user_sign_out
  visit signout_path
end
#------>>
def set_current_user(user = nil)
 session[:user_id] = (user || Fabricate(:user)).id
end
def clear_current_user
   session[:user_id] = nil
end
def current_user
 User.find(session[:user_id])
end
#------>>

def click_on_video_on_home_page(video)
  #find("a[href='/videos/#{video.to_param}']").click
  link_url = "a[href='#{video_path(video)}']"
  find(link_url).click
end