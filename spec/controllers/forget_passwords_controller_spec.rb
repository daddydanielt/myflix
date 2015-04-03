require 'spec_helper'

describe ForgetPasswordsController do
  describe "Post#create" do
    context "with blank input email address" do
      it "rediret to the forget_password_path" do
        post :create, email: ""
        expect(response).to redirect_to forget_password_path
      end
      it "show the flash error message" do
        post :create, email: ""
        expect(flash[:error]).to be_present
      end
    end
    context "the mail address doesn't exist in the system" do
      it "show the flash error message" do
        post :create, email: "not_exit@test.com"
        expect(flash[:error]).to be_present
      end
      it "redirect to forget_password_path" do
        post :create, email: "not_exit@test.com"
        expect(response).to redirect_to forget_password_path
      end
    end
    context "correct mail address "  do
      let(:mary) { Fabricate(:user) }
      before do
        post :create, email: mary.email
      end
      it "send reset password email to mail address" do
        email =  ActionMailer::Base.deliveries.last
        expect(email.to).to eq([mary.email])
      end
      it "render the confirm_password_reset template" do
        email =  ActionMailer::Base.deliveries.last
        expect(response).to render_template(:confirm_password_reset)
      end
    end
  end
end