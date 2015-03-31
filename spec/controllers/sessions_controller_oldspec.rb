require 'spec_helper'

describe SessionsController do    
  describe "Get#new"  do
    binding.pry
    context "if user has already logged in" do  
      it "redirect to home_path" do        
        binding.pry
        set_current_user
        binding.pry
        get :new 
        binding.pry
        expect(response).to redirect_to(home_path)
      end      
    end

    context "user doesn't sign in yet" do
      before do 
        get :new 
      end
      it "set @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "render :new templatet" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "Post#create" do                  
    context "@user exist and @user.authenticate is passed" do                                         
      #user_params = Fabricate.attributes_for(:user)          
      #user_Mary = User.create(user_params)                     
      user_Mary = Fabricate(:user)
      before do          
        post :create, user: { email: user_Mary.email, password: user_Mary.password, full_name: user_Mary.full_name }           
      end

      it "set session[:user_id]" do          
        expect(session[:user_id]).to eq(user_Mary.id)
      end        

      it "set flash[:notice] message" do
        expect(flash[:notice]).not_to be_blank
        expect(flash[:notice]).to eq("Successfull SignIn")          
      end

      it "redirect_to home_path" do
        expect(response).to redirect_to(home_path)
      end
    end

      context "@user doesn't exist" do
        user_params = Fabricate.attributes_for(:user)                                    
        before do 
          post :create, user: user_params
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

      context "@user fail to authenticate" do        
        user = Fabricate(:user)                   
        error_password = user.password + "error password"         
        before do 
          post :create, user: { email: user.email, password: error_password }
        end                                    
        
        it "@user fail to authenticate" do
          expect( assigns(:user).authenticate(error_password) ).to be_falsey
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
      it "clear the session for the user" do        
        session[:user_id] = Fabricate(:user).id        
        get :destroy   
        expect(session[:user_ud]).to be_nil     
      end

      it "set the flash[:notice]"

      it "redirect to root_path"
    end
end