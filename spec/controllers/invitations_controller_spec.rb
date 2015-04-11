require 'spec_helper'

describe InvitationsController do
  describe "Get#show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
    before do
      set_current_user
    end
    it "sets @invitation to a new invitaion" do
      get :new
      expect(assigns(:invitation)).to be_instance_of Invitation
      expect(assigns(:invitation)).to be_new_record
    end
    it "render show template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "Post#create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end
    context "with invalid input" do
      before { set_current_user }
      after do
        ActionMailer::Base.deliveries.clear
      end
      it "show the flash[:notice] message" do
        invalid_params = { recipient_name: "Bob", recipient_email: "", invitation_message: "Hello this is an invitation" }
        post :create,  invitation: invalid_params
        expect(flash[:notice]).to be_present
      end
      it "render to new_invitation_path" do
        invalid_params = { recipient_name: "Bob", recipient_email: "", invitation_message: "Hello this is an invitation" }
        post :create,  invitation: invalid_params
        expect(response).to render_template(:new)
      end
      
      it "doesn't create the invitaion, with empty recipient_email." do
        invalid_params = { recipient_name: "Bob", recipient_email: "", invitation_message: "Hello this is an invitation" }
        post :create,  invitation: invalid_params
        expect(Invitation.all.count).to eq(0)
      end
      it "doesn't create the invitaion, with empty recipient_name." do
        invalid_params= { recipient_name: "", recipient_email: "bob@test.com", invitation_message: "Hello this is an invitation" }
        post :create,  invitation: invalid_params
        expect(Invitation.all.count).to eq(0)
      end
      it "doesn't send out the eamil"  do
        invalid_params= { recipient_name: "", recipient_email: "bob@test.com", invitation_message: "Hello this is an invitation" }
        post :create,  invitation: invalid_params
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it "set @invitation " do
        invalid_params= { recipient_name: "", recipient_email: "bob@test.com", invitation_message: "Hello this is an invitation" }
        post :create,  invitation: invalid_params
        expect(assigns(:invitation)).to be_present
      end
    end # End context "with invalid input"

    context "with valid input" do
      before do
        set_current_user
      end
      after do
        ActionMailer::Base.deliveries.clear
      end
      it "redirects to the invitation new page" do
        post :create,  invitation: { recipient_name: "Bob", recipient_email: "bob@test.com", invitation_message: "Hello this is an invitation" }
        expect(response).to redirect_to new_invitation_path
      end
      it "create an invitation" do
        post :create,  invitation: { recipient_name: "Bob", recipient_email: "bob@test.com", invitation_message: "Hello this is an invitation" }
        expect(Invitation.all.last.recipient_email).to eq("bob@test.com")
      end
      it "sends an email to the recipient" do
        post :create,  invitation: { recipient_name: "Bob", recipient_email: "bob@test.com", invitation_message: "Hello this is an invitation" }
        email =  ActionMailer::Base.deliveries.last
        expect(email.to).to eq(["bob@test.com"])
      end
      
      it "sets the flash success message" do
        post :create,  invitation: { recipient_name: "Bob", recipient_email: "bob@test.com", invitation_message: "Hello this is an invitation" }
        expect(flash[:success]).to be_present
      end

      #it "send invite email to the friend's email" do
      #  post :create, friend_name: "Bob", friend_email: "bob@test.com", invitation_message: "Myflix is an awesome online video watching service."
      #  email =  ActionMailer::Base.deliveries.last
      #  expect(email.to).to eq([mary.email])
      #end
  #
  #    #it "redirect to xxx" do
  #
      #end
    end # End context "with valid input" do

  end
end