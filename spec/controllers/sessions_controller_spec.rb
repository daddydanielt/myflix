require 'spec_helper'

describe SessionsController do
  describe "Get#new" do 
    context "with authenticated user" do 
      it "redirect to home_path" do 
        set_current_user
        get :new
        expect(response).to redirect_to(home_path)
      end
    end
    context "with unathenticated user" do 
      before do         
        get :new
      end
      it "set @user" do         
        expect(assigns(:user)).to be_instance_of(User)
      end
      it "render :new template " do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "Post#create" do 
    context "The @user is existed, and @user has passed the authentication" do 
      let(:mary) { Fabricate(:user) }
      before do          
        post :create, user: { email: mary.email, password: mary.password, full_name: mary.full_name }           
      end
      it "set session[:user_id]" do 
        expect(session[:user_id]).to eq(mary.id)
      end

      it "set flash[:notice] message" do
        expect(flash[:notice]).not_to be_blank
        expect(flash[:notice]).to eq("Successfull SignIn")          
      end

      it "redirect_to home_path" do
        expect(response).to redirect_to(home_path)
      end
    end
    context "The @user is not existed" do 
      before do 
        post :create, user: { email: Faker::Internet.email, password: Faker::Internet.password, full_name: Faker::Name.name }
      end
      it "@user is nil" do
        expect(assigns(:user)).to eq(nil)          
      end
      it "set the flash[:notice]" do
        expect(flash[:notice]).to eq("Permission denied.")
      end
      it "redirect_to signin_path" do          
        expect(response).to redirect_to(signin_path)
      end
    end
    context "The @user doesn't pass the authentication" do 
      let(:mary) { Fabricate(:user) }
      let(:error_password) { mary.password+"_error" }
      before do 
        post :create, user: { email: mary.email, password: error_password, full_name: mary.full_name }           
      end      
      it "set the flash[:notice]" do
        expect(flash[:notice]).to eq("Permission denied.")
      end
      it "redirect_to signin_path" do          
        expect(response).to redirect_to(signin_path)
      end
    end
  end

  describe "Get#destroy" do
    context "with authenticate user" do
      before do
        set_current_user
        get :destroy   
      end
      it "clear the session for the user" do        
        expect(session[:user_ud]).to be_nil     
      end

      it "set the flash[:notice]" do 
        expect(flash[:notice]).to be_present
      end
      it "redirect to root_path" do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end