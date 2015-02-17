require 'spec_helper'

describe MyQueuesController  do
  context "with authenticated user" do
    let(:current_user) { Fabricate(:user) }    
    
    before do
      session[:user_id] = current_user.id
    end

    it "set @my_queues associated with current_user" do            
      #current_user.my_queues << Fabricate(:my_queue, video: )
      video = Fabricate(:video)
      my_queue_1 = Fabricate(:my_queue, user: current_user, video: video)
      my_queue_2 = Fabricate(:my_queue, user: current_user, video: video)
      get :index
      #expect(assigns(:my_queues)).to match_array(current_user.my_queues)
      expect(assigns(:my_queues)).to match_array([my_queue_1,my_queue_2])
    end

    it "render template :index" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  context "with unauthenticaed user" do
    it "redirect_to signin_path" do
      get :index
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "Post#create" do

    context "with authenticated user" do
      let(:current_user) { Fabricate(:user) }    
      let(:video) { Fabricate(:video) }
      
      before do
        session[:user_id] = current_user.id        
      end

      it "redirect_to my_queues_path" do
        post :create, video: video.id
        expect(response).to redirect_to(my_queues_path)
      end

      it "create the my_queue assoicated with the video & current_user" do
        post :create, video: video.id
        expect(current_user.my_queues.first.video).to eq(video)
      end

      it "puts the last one position in the queue" do
        v1 = Fabricate(:video)
        v2 = Fabricate(:video)
        v3 = Fabricate(:video)
        post :create, video: v1
        post :create, video: v2
        post :create, video: v3      
        videos = current_user.my_queues.order("list_order ASC").map { |my_queue| my_queue.video }
        expect(videos).to eq([v1,v2,v3])
      end

      it "doesn't add the same video twice." do        
        post :create, video: video.id        
        post :create, video: video.id
        post :create, video: video.id
        expect(current_user.my_queues.count).to eq(1)
      end

    end

    context "unauthenticated user" do
      it "redirect_to the signin_path for unauthenticaed user" do
        video = Fabricate(:video)        
        post :create, video: video.id
        expect(response).to redirect_to(signin_path)   
      end
    end    
  end

  describe "DELETE#destroy" do    
    context "authenticated user" do      
      let(:current_user) { Fabricate(:user) }    
      before do
        session[:user_id] = current_user.id
      end

      it "redirect_to my_queues_path" do
        video = Fabricate(:video)      
        my_queue = Fabricate(:my_queue, video: video, user: current_user)

        delete :destroy, id: my_queue.id

        expect(response).to redirect_to(my_queues_path) 
      end

      it "delete one of current_user's my_queue according the params[:id]" do
        video = Fabricate(:video)
        post :create, video: video
        expect(current_user.my_queues.count).to eq(1)        
        delete :destroy, id: current_user.my_queues.first.id
        expect(current_user.my_queues.count).to eq(0)
      end

      it "doesn't delete the my_queue which is not belonging to the current_user" do
        video = Fabricate(:video)
        user = Fabricate(:user)
        my_queue = Fabricate(:my_queue, video: video, user: user)        
        delete :destroy, id: my_queue.id
        expect(user.my_queues.first).to eq(my_queue)        
      end

    end

    context "unauthenticated user" do
      it "redirect_to the signin_path for unauthenticaed user" do                          
        video = Fabricate(:video)
        delete :destroy, id: video.id
        expect(response).to redirect_to(signin_path)   
      end
    end  
  end
end

