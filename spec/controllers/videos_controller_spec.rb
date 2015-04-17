require 'spec_helper'

describe VideosController do
  describe "GET#search" do
    it "ste the @videos instance variable if the user is authenticated" do
      session[:user_id] = Fabricate(:user).id
      video1 = Fabricate(:video, title: "Family-1")
      video2 = Fabricate(:video, title: "Family-2")
      video3 = Fabricate(:video, title: "Family-3")
      video4 = Fabricate(:video, title: "you can't find me")
      post :search, search_pattern: "Family"
      expect(assigns(:videos)).to match_array([video1, video2, video3])
    end

    it "redirect the user to signin path if the user is not authenticated" do
      video1 = Fabricate(:video, title: "Family-1")
      post :search, search_pattern: "Family"
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "GET#show" do
    it "set the @video instance variable if the user is authenticated" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      video2 = Fabricate(:video)
      get :show, id: video.to_param
      expect(assigns(:video)).to eq(video)
    end

    it "redirect the user to signin_path if the user is not authenticated" do
      video = Fabricate(:video)
      video2 = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "GET#show" do
    context "with authenticate users" do
      before do
        session[:user_id] = Fabricate(:user).id
        #@video = Fabricate(:video)
      end
      
      it "sets the @video instance variable" do
        #--->
        #get :show, id: @video.id
        #expect(assigns(:video)).to eq(@video)
        #--->
        video = Fabricate(:video)
        video2 = Fabricate(:video)
        get :show, id: video.to_param
        expect(assigns(:video)).to eq(video)
        #--->
      end

      it "sets @reviews for authenticated users" do
        video = Fabricate(:video)
        review1  = Fabricate(:review, video: video)
        review2  = Fabricate(:review, video: video)
        get :show, id: video.to_param
        expect( assigns( :reviews )).to match_array [review1,review2]
        assigns(:reviews).should =~ [review1,review2]
      end

      it "redirect to 'home_path' if @video instance variable isn't existing."

      it "render the 'show' template if @video is existing" do
        video = Fabricate(:video)
        get :show, id: video.to_param
        #--->
        #expect(response).to render_template: :show
        #--->
        response.should render_template(:show)
        #--->
      end
    end

    context "with unauthenticate users" do
      it "redirect the user to the signin path" do
         #--->
        video = Fabricate(:video)
        video2 = Fabricate(:video)
        get :show, id: video.to_param
        expect( response ).to redirect_to(signin_path)
        #--->
      end
    end
  end

  describe "GET #show" do
    #it "set @video instance variable" do
    #  user = Fabricate(:user)
    #  video = Fabricate(:video)
    #  session[:user_id] = user.id
    #  get :show, id: video.id
    #  #assigns(:video).should be_new_record
    #  binding.pry
    #  assigns(:video).should be_an_instance_of(Video)
    #end
    
    it "redirect to 'home_path' if @video instance variable isn't existing."
    it "render the 'show' template if @video is existing"
  end

  describe "POST #search" do
    it "set @videos instance variable"
    it "render 'search' template"
  end

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
      assigns(:video2).should be_new_record
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
