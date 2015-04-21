require 'spec_helper'

describe Admin::VideosController do
  
  describe "GET #new" do
    it_behaves_like "requires sign in" do
      let(:action) {get :new}
    end
    it_behaves_like "requires admin" do
      let(:action) {get :new}
    end
    it "render the new template" do
      set_current_user_with_admin
      get :new
      expect(response).to render_template(:new)
    end
    it "sets the @video instance variable" do
      set_current_user_with_admin(Fabricate(:admin))
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end
  end

  describe 'POST #create' do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end
    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end
    
    context "valid input" do
      #b_cover_file = ""
      #s_cover_file = ""
      let(:category) { Fabricate(:category) }
      let(:video_attributes) { Fabricate.attributes_for(:video, category: category) }
      before do
        set_current_user_with_admin
        post :create, video: video_attributes
      end
      it "creates a new video" do
        expect(Video.count).to eq(1)
        #expect(Video.count).to eq(1)
      end
      it "sets flash[:success] message" do
        expect(flash[:success]).to be_present
      end
      it "redirects to new_admin_video_path" do
        expect(response).to redirect_to(new_admin_video_path)
      end
    end

    context "invalid input" do
      let(:category) { Fabricate(:category) }
      let(:video_attributes) { {title: nil , category_id: category, description: nil} }
      before do
        set_current_user_with_admin
        post :create, video: video_attributes
      end
      it "doesn't create a new video" do
        expect(Video.count).to eq(0)
      end
      it "renders :new template" do
        expect(response).to render_template(:new)
      end
      it "sets the @video variable" do
        #expect(assigns(:video)).to be_instance_of(Video)
        #expect(assigns(:video)).to be_new_record(Video)
        expect(assigns(:video)).to be_a_new(Video)
      end
      it "sets the flash[:error] message" do
        expect(flash[:error]).to be_present
      end
    end
    
  end
end
