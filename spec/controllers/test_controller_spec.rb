require 'spec_helper'

describe SessionsController do
  describe "Get#new" do #user sing
    context "user has already logged in" do      
      it "redirect to home_path" do                
        user = Fabricate(:user)
        session[:user_id] = user.id        
        get :new
        expect(response).to redirect_to(home_path)
      end
    end
    context "user doesn't login" do
      it "set @user" do
        get :new
        expect(assigns(:user)).to be_instance_of(User)
      end
    end    
  end

  describe "Post#create" do #user sign_in
    describe "before_action: signin_params" do
      context "missing strong_parameters" do
        it "set flash[:notice]" do                    
          #expect { post :create }.to raise_error(ActionController::ParameterMissing)                    
          post :create, user: {no_email: "", no_password: ""}
          binding.pry
          flash[:notice].size.should > 0
        end

        it "redirect to signin_path" do
           post :create
           expect(response).to redirect_to(signin_path)
        end
      end
      it "return strong_parameters hash" do
        @controller = SessionsController.new                
        post :create, user: Fabricate.attributes_for(:user)        
        r = @controller.instance_eval{ signin_params }
        r.keys.map{|k| k.to_sym} == [:email, :password]        
      end
    end

    it "set @user" do

    end    
  end

  describe "Get#destroy" do #user sign_out

  end
end