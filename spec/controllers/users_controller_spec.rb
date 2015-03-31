require 'spec_helper'

describe UsersController do
  
#  describe "GET show" do
#    
#    context "with authenticated user" do
#      it "set @user" do
#        set_current_user
#        mary = Fabricate(:user)
#        get :show, id: mary.id
#        expect(assigns(:user)).to be_instance_of(User)
#      end
#    end
#
#    context "with unauthenticated user" do      
#      #note: shared example => "require sign in"
#      it_behaves_like "requires sign in" do
#        mary = Fabricate(:user)
#        let(:action) { get :show, id: mary.id }
#      end
#    end
#    
#  end
#
#  describe "GET new" do
#    it "set @user " do
#      get :new 
#      expect(assigns(:user)).to be_instance_of(User)
#    end
#  end
#
  describe "GET show" do    
    context "with authenticated user" do
      it "set @user" do
        set_current_user
        mary = Fabricate(:user)
        get :show, id: mary.id        
        expect(assigns(:user)).to be_instance_of(User)
        expect(assigns(:user)).to eq(mary)
      end
    end

    context "with unauthenticated user" do      
      #note: shared example => "require sign in"
      # --->
      # note: This will let db:test remains the mary = Fabricate(:user), it will cause the following testing fail.
      #it_behaves_like "requires sign in" do
      #  mary = Fabricate(:user)
      #  let(:action) { get :show, id: mary.id }
      #end
      # --->
      it_behaves_like "requires sign in" do                        
        let(:action) { get :show, id: 1 }
      end
    end
  end # End describe "GET show"

  describe "GET new" do
   it "set @user " do
     get :new 
     expect(assigns(:user)).to be_instance_of(User)
   end
  end # End describe "GET new"

  describe "POST create" do
    context "with valid input" do 
      let(:user_params) { Fabricate.attributes_for(:user) }
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