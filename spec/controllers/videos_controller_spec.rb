require 'spec_helper'

describe VideosController do
  #describe "GET #index"  do   
  #  describe "After logged_in" do            
  #    it "sets the @categories variable" do
  #      c1 = Category.create(title: "Family")
  #      c2 = Category.create(title: "Sports")
  #      u =  User.create(email: "qqq@gmail.com", password: "qqq", full_name: "QQQ")
  #      get :index, {}, { 'user_id' => u.id } #session[:user_id]
  #      assigns(:categories).should == [c1, c2]      
  #    end
  #    
  #    it "render the index template" do
  #      u =  User.create(email: "qqq@gmail.com", password: "qqq", full_name: "QQQ")      
  #      get :index, {}, { 'user_id' => u.id } #session[:user_id]
  #      response.should render_template(:index)
  #    end
  #  end
  #end 

  describe "GET #new" do
    it "sets the @video instance variable" do
      u =  User.create(email: "qqq@gmail.com", password: "qqq", full_name: "QQQ")
      get :new, {}, { 'user_id' => u.id } #session[:user_id]
      assigns(:video).should be_an_instance_of(Video)
      assigns(:video).should be_new_record
    end

    it "render the new template" do
      u =  User.create(email: "qqq@gmail.com", password: "qqq", full_name: "QQQ")
      get :new, {}, { 'user_id' => u.id } #session[:user_id]      
      response.should render_template(:new)
    end
  end

  describe "POST #create" do
    it "create the new video record when the input is valid" do
      u =  User.create(email: "qqq@gmail.com", password: "qqq", full_name: "QQQ")
      post :create, {video: {title: "test-ok", description: "test-ok"}}, { 'user_id' => u.id } #session[:user_id]      
      v = Video.first
      v.title.should == "test-ok"      
      v.description.should == "test-ok"
    end
    it "redirects to the newly created video path" do
      u =  User.create(email: "qqq@gmail.com", password: "qqq", full_name: "QQQ")
      post :create, {video: {title: "test-ok", description: "test-ok"}}, { 'user_id' => u.id } #session[:user_id]      
      response.should redirect_to video_path(Video.first)
    end
    

    it "doesn't create the video when the inpute is invalid" do
      u =  User.create(email: "qqq@gmail.com", password: "qqq", full_name: "QQQ")
      post :create, {video: {description: "test-ok"}}, { 'user_id' => u.id } #session[:user_id]      
      Video.count.should == 0     
    end

    it "render the new template when the inpute is invalid" do
      u =  User.create(email: "qqq@gmail.com", password: "qqq", full_name: "QQQ")
      post :create, {video: {description: "test-ok"}}, { 'user_id' => u.id } #session[:user_id]            
      response.should render_template(:new)
    end
  end
end
