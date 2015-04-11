require 'spec_helper'

describe UsersController do
  describe "GET#reset_password" do
     
  end

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

  describe "GET new_with_invitation_token" do
    context "@invitation token is valid" do
      it "set @user with recipient_email" do
        invitation = Fabricate(:invitation)
        get :new_with_invitation_token, token: invitation.token
        expect(assigns(:user).email).to eq(invitation.recipient_email)
      end
      it "set @invitation" do
        invitation = Fabricate(:invitation)
        get :new_with_invitation_token, token: invitation.token
        expect(assigns(:invitation)).to be_instance_of(Invitation)
      end
      it "render :new template" do
        invitation = Fabricate(:invitation)
        get :new_with_invitation_token, token: invitation.token
        expect(response).to render_template(:new)
      end
    end
    context "@invitation token is invalid" do
      it "redirect to invalid_token_path" do
        get :new_with_invitation_token, token: ""
        expect(response).to redirect_to invalid_token_path
      end
    end
  end # End describe "GET new_with_invitation_token"

  describe "POST create" do
    context "with valid input" do
      let(:user_params) { Fabricate.attributes_for(:user) }
      # user_params_b = {email: Faker::Internet.email, password: Faker::Internet.password, full_name: Faker::Name.name}
      #before {  post :create, user: user_params }
    
      context "with invitation_token" do
        it "follow the inviter" do
          mary = Fabricate(:user)
          invitation = Fabricate(:invitation, inviter_id: mary.id )
          post :create, user: user_params, invitation_token: invitation.token
          expect(assigns(:user).the_users_i_following).to include(mary)
        end
        it "the inviter follow the user" do
          mary = Fabricate(:user)
          invitation = Fabricate(:invitation, inviter_id: mary.id )
          post :create, user: user_params, invitation_token: invitation.token
          expect(mary.the_users_i_following).to include(assigns(:user))
        end

        it "expires the invitation tokn upon acceptance" do
          mary = Fabricate(:user)
          invitation = Fabricate(:invitation, inviter_id: mary.id )
          post :create, user: user_params, invitation_token: invitation.token
          expect(invitation.reload.token).to be_nil
        end
      end

      it "set @user" do
        post :create, user: user_params
        expect(assigns(:user)).to eq(User.first)
      end
      it "create the user" do
        post :create, user: user_params
        expect(User.first.email).to eq(user_params[:email])
        expect(User.first.full_name).to eq(user_params[:full_name])
        expect(User.first.authenticate(user_params[:password])).to eq(User.first)
      end
      context "email sending" do
        it "send out the email" do
          post :create, user: user_params
          ActionMailer::Base.deliveries.should_not be_empty
        end
        it "has the right content" do
          post :create, user: user_params
          email = ActionMailer::Base.deliveries.last
          expect(email.body).to include(user_params[:full_name])
        end
        it "sneds to the right recipient" do
          post :create, user: user_params
          email = ActionMailer::Base.deliveries.last
          expect(email.to.first).to eq(user_params[:email])
        end
      end
      it "redirect to the signin_path" do
        post :create, user: user_params
        expect(response).to redirect_to(signin_path)
      end
    end

    context "with invalid input" do
      # invalid params: miss :email attribute
      #user_params = { password: Faker::Internet.password, full_name: Faker::Name.name}
      let(:user_params) { Fabricate.attributes_for(:user).slice(:email, :full_name) }
      before { post :create, user: user_params }
      after { ActionMailer::Base.deliveries.clear }
      it "set @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
      it "doesn't create the user" do
        #expect(User.all.size).to eq(0)
        expect(User.count).to eq(0)
      end
      it "doesn't send email to the user" do
        #--->
        # I add the after{} filter to clear the ActionMailer::Base.delieveries count
        #email = ActionMailer::Base.deliveries.last
        #email.to.should_not eq(user_params[:email])
        #--->
        expect(ActionMailer::Base.deliveries.count).to eq(0)
        #--->
      end
      it "render :new template" do
        expect(response).to render_template(:new)
      end
    end
  end # End describe "POST create"
end

 
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