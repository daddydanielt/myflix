require 'spec_helper'

describe RelationshipsController do  
  describe "PODT#create" do 
    it_behaves_like "requires sign in" do
      let( :action )  { post :create, following_user_id: Fabricate(:user) }
    end
    context "with authenticated user" do 
      let(:mary) { Fabricate(:user) }
      before do 
        set_current_user        
        post :create, following_user_id: mary.id
      end
      it "should add the following relationship for the current_user" do
        expect(current_user.the_users_i_following.last).to eq(mary)  
      end      
      it "should redirect to people_path" do
        expect(response).to redirect_to(people_path)
      end
    end
  end
  describe "GET#followings" do
    it_behaves_like "requires sign in" do
      let( :action ) { get :following }
    end
    context "with authenticated user" do
      it "should render followings template" do
        set_current_user
        get :following
        expect(response).to render_template(:following)
      end
    end
  end

  describe "DELETE#destroy" do
    context "with unauthenticated user" do
      it_behaves_like "requires sign in" do    
        let(:action) { delete :destroy, id: 1 }
      end
    end
    context "with authenticated user" do                        
      before do 
        set_current_user 
      end
      context "successfully delete the current_user's followings relationship" do
        before do 
          Fabricate(:relationship, follower: current_user, following: Fabricate(:user))
          relationship = Fabricate(:relationship, follower: current_user, following: Fabricate(:user))
          delete :destroy, id: relationship  
        end        
        it "delete relationship against the specific userif the current_user is a follower." do                  
          expect(Relationship.all.count).to eq(1)
          expect(current_user.the_users_i_following.count).to eq(1)
        end
        it "shows the flash[:notice] messages if successfully delete the following relationship for the current_user" do
          expect(flash[:notice]).to be_present
        end
      end
      context "unsuccessfully delete the current_user's followings relationship" do
        before do 
          relationship =  Fabricate(:relationship, follower: Fabricate(:user), following: Fabricate(:user))
          delete :destroy, id: relationship
        end
        it "doesn't delete relationship against the specific user, if the current_user is not a follower." do                      
          expect(Relationship.all.count).to eq(1)
        end
        it "shows the flash[:error] messages if unsuccessfully delete the following relationship for current_user" do           
          expect(flash[:error]).to be_present
        end
      end    
      it "redirect to the people page" do 
        delete :destroy, id: 1
        expect(response).to redirect_to(people_path)
      end
    end
  end
end