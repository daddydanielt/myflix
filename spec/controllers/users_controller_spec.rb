require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "set @user " do
      get :new 
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid input" do 
       user_params = Fabricate.attributes_for(:user)
      # user_params_b = {email: Faker::Internet.email, password: Faker::Internet.password, full_name: Faker::Name.name}
      
      before { post :create, user: user_params }

      it "set @user" do                        
        #post :create, user: user_params        
        expect(assigns(:user)).to eq(User.first)
      end
      
      it "create the user" do        
        #post :create, user: user_params        
        expect(User.first.email).to eq(user_params[:email])         
        expect(User.first.full_name).to eq(user_params[:full_name]) 
        expect(User.first.authenticate(user_params[:password])).to eq(User.first) 
      end

      it "redirect to the signin_path" do
        #post :create, user: user_params
        expect(response).to redirect_to(signin_path)                
      end
    end

    context "with invalid input" do     
      
      # invalid params: miss :email attribute
      #user_params = { password: Faker::Internet.password, full_name: Faker::Name.name} 
      before { post :create, user: Fabricate.attributes_for(:user).slice(:password, :full_name) }
      
      it "set @user" do
        expect(assigns(:user)).to be_instance_of(User) 
      end

      it "doesn't create the user" do        
        #expect(User.all.size).to eq(0)
        expect(User.count).to eq(0)
      end
      it "render :new template" do        
        expect(response).to render_template(:new)
      end
    end 
  end

end