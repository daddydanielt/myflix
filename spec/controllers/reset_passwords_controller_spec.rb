require 'spec_helper'

describe ResetPasswordsController do
  describe "GET#show" do
    context "token is valid" do
      it "set @user " do
        #user = Fabricate(:user, token: SecureRandom.urlsafe_base64 )
        user = Fabricate(:user)
        get :show, id: user.token
        expect(assigns(:user)).to be_instance_of(User)
      end
      it "render show template" do
        user =Fabricate(:user)
        get :show, id: user.token
        expect(response).to render_template(:show)
      end
    end
    context "token is invalid" do
      it "redirect to invalid_token_path" do
        user = Fabricate(:user)
        get :show, id: "This is a invalid token."
        expect(response).to redirect_to(invalid_token_path)
      end
      it "show the flash[:notice] message" do
        get :show, id: "This is a invalid token."
        expect(flash[:notice]).to be_present
      end
    end
  end

  describe "POST#create" do
    context "with valid token and new_password params" do
      let(:user) { Fabricate(:user, password:"ori_password") }
      let(:ori_token) { user.token }
      let(:new_password) { "new_password" }
      before do
        post :create, new_password: new_password, token: ori_token
      end
      it "set new password to the user with corresponding token value." do
        expect(user.reload.authenticate(new_password)).to be_instance_of User
      end
      it "generate the new token for the user." do
        new_token = user.reload.token
        new_token.should_not eq(ori_token)
      end
      it "show the flash[:notice]" do
        expect(flash[:notice]).to be_present
      end
      it "redirect to the signin_path" do
        expect(response).to redirect_to signin_path
      end
    end
    context "with invalid token and new_password params" do
      let(:ori_password) { "ori_password"}
      let(:user) { FAbricate(:user, password: ori_password) }
      let(:new_password ) { "" }
      before do
        post :create, token: "this_is_a_valid_token", password: new_password
      end
      it "show the flash[:notice] message" do
        expect(flash[:warning]).to be_present
      end
      it "redirect to the invalid_token_path" do
        expect(response).to redirect_to invalid_token_path
      end
    end
  end
end