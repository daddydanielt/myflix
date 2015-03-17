require 'spec_helper'

describe MyQueuesController  do

  describe "POST#update_all" do
    it_behaves_like "requires sign in" do
      let(:video_1) { Fabricate(:video) }
      let(:video_2) { Fabricate(:video) }
      let(:my_queue_1) { Fabricate(:my_queue, list_order: 1, user: nil, video: video_1) }
      let(:my_queue_2) { Fabricate(:my_queue, list_order: 2, user: nil, video: video_2)         }
      let(:action) { post :update_all, my_queues: [{id:my_queue_1.id, list_order:2}, {id:my_queue_2.id, list_order:1}] }
    end

    context "with authenticated user" do
      let(:current_user) { Fabricate(:user) }      
      let(:video_1) {Fabricate(:video)}
      let(:video_2) {Fabricate(:video)}
      let(:my_queue_1) { Fabricate(:my_queue, list_order: 1, user: current_user, video: video_1) }
      let(:my_queue_2) { Fabricate(:my_queue, list_order: 2, user: current_user, video: video_2) }
             
      before do
        #video_1 = Fabricate(:video)
        #video_2 = Fabricate(:video)
        #my_queue_1 = Fabricate(:my_queue, list_order: 1, user: current_user, video: video_1)
        #my_queue_2 = Fabricate(:my_queue, list_order: 2, user: current_user, video: video_2)
        session[:user_id] = current_user.id
      end

      context "with valid input" do        

        it "reorder the my_queue items" do
          #video_1 = Fabricate(:video)
          #video_2 = Fabricate(:video)
          #my_queue_1 = Fabricate(:my_queue, list_order: 1, user: current_user, video: video_1)
          #my_queue_2 = Fabricate(:my_queue, list_order: 2, user: current_user, video: video_2)

          post :update_all, my_queues: [{id:my_queue_1.id, list_order:2}, {id:my_queue_2.id, list_order:1}]          

          #my_queue_1_list_order_new = MyQueue.find(my_queue_1.id).list_order
          #my_queue_2_list_order_new = MyQueue.find(my_queue_2.id).list_order
          #expect("#{my_queue_1_list_order_new}:#{my_queue_2_list_order_new}").to eq("2:1")          
          
          #expect(current_user.my_queues.order("list_order ASC")).to eq([my_queue_2,my_queue_1])
          expect(current_user.my_queues).to eq([my_queue_2,my_queue_1])
        end

        it "redirect_to my_queues_path" do       
          #video_1 = Fabricate(:video)
          #video_2 = Fabricate(:video)
          #my_queue_1 = Fabricate(:my_queue, list_order: 1, user: current_user, video: video_1)
          #my_queue_2 = Fabricate(:my_queue, list_order: 2, user: current_user, video: video_2)
          
          #post :update_all, my_queues: [{"id"=>"#{my_queue_1.id}", "list_order"=>"2"}, {"id"=>"#{my_queue_2.id}", "list_order"=>"1"}]
          post :update_all, my_queues: [{id:my_queue_1.id, list_order:2}, {id:my_queue_2.id, list_order:1}]
          expect(response).to redirect_to(my_queues_path)
        end
        
        it "normalize the lisr_order value" do          
          #my_queue_1 = Fabricate(:my_queue, list_order: 1, user: current_user, video: Fabricate(:video))
          #my_queue_2 = Fabricate(:my_queue, list_order: 2, user: current_user, video: Fabricate(:video))
          mass_update_params = [{id:my_queue_1.id, list_order:3}, {id:my_queue_2.id, list_order:2}]
          post :update_all, my_queues: mass_update_params         
          expect(current_user.my_queues.map(&:list_order)).to eq([1,2])
        end
      end

      context "with unvalid input" do
        let(:current_user) { Fabricate(:user)}
        let(:my_queue_1) { Fabricate(:my_queue, list_order: 2, user: current_user, video: Fabricate(:video)) }
        let(:my_queue_2) { Fabricate(:my_queue, list_order: 3, user: current_user, video: Fabricate(:video)) }
        
        before do
          #my_queue_1 = Fabricate(:my_queue, list_order: 2, user: current_user, video: Fabricate(:video))
          #my_queue_2 = Fabricate(:my_queue, list_order: 3, user: current_user, video: Fabricate(:video))
          session[:user_id] = current_user.id
        end

        it "redirect_to my_queues_path" do          
          #my_queue_1 = Fabricate(:my_queue, list_order: 2, user: current_user, video: Fabricate(:video))
          #my_queue_2 = Fabricate(:my_queue, list_order: 3, user: current_user, video: Fabricate(:video))
          unvalid_mass_update_params = [{id:my_queue_1.id, list_order:1.1}, {id:my_queue_2.id, list_order:2.1}]
          post :update_all, my_queues: unvalid_mass_update_params 
 
          expect(response).to redirect_to(my_queues_path)
        end

        it "doesn't change my_queues's items" do
          #my_queue_1 = Fabricate(:my_queue, list_order: 2, user: current_user, video: Fabricate(:video))
          #my_queue_2 = Fabricate(:my_queue, list_order: 3, user: current_user, video: Fabricate(:video))
          unvalid_mass_update_params = [{id:my_queue_1.id, list_order:1.1}, {id:my_queue_2.id, list_order:2.1}]
          post :update_all, my_queues: unvalid_mass_update_params           
          #expect(current_user.my_queues.map(&:list_order)).to eq([2,3])          
          expect(my_queue_1.reload.list_order).to eq(2)
          expect(my_queue_2.reload.list_order).to eq(3)
        end

        it "shows the flash messages" do
          #my_queue_1 = Fabricate(:my_queue, list_order: 2, user: current_user, video: Fabricate(:video))
          #my_queue_2 = Fabricate(:my_queue, list_order: 3, user: current_user, video: Fabricate(:video))
          unvalid_mass_update_params = [{id:my_queue_1.id, list_order:1.1}, {id:my_queue_2.id, list_order:2.1}]
          post :update_all, my_queues: unvalid_mass_update_params 
          expect(flash[:error]).to be_present
        end                   
      end

      context "with my_queue items which don't belongs to the current_user" do
        let(:current_user) { Fabricate(:user) }
        before do
          session[:user_id] = current_user.id
        end

        it "doesn't update these my_queue items" do
        end

        it "redirect_to my_queues_path" do
          other_user = Fabricate(:user)          
          video_1 = Fabricate(:video)  
          video_2 = Fabricate(:video)  
          other_user_my_queue_1 = Fabricate(:my_queue, list_order: 1, user: other_user, video: video_1)
          other_user_my_queue_2 = Fabricate(:my_queue, list_order: 2, user: other_user, video: video_2)

          post :update_all, my_queues: [{id:other_user_my_queue_1.id, list_order:2}, {id:other_user_my_queue_2.id, list_order:1}]
          expect(response).to redirect_to(my_queues_path)
        end

      end
    end # End context "authenticated user" 

    #context "with unauthenticaed user" do
    #  it "redirect_to signin_path" do
    #    video_1 = Fabricate(:video)
    #    video_2 = Fabricate(:video)
    #    my_queue_1 = Fabricate(:my_queue, list_order: 1, user: nil, video: video_1)
    #    my_queue_2 = Fabricate(:my_queue, list_order: 2, user: nil, video: video_2)        
    #    post :update_all, my_queues: [{id:my_queue_1.id, list_order:2}, {id:my_queue_2.id, list_order:1}]          
    #    expect(response).to redirect_to(signin_path)
    #  end
    #end # End context "unauthenticaed user" 
  end # End describe "POST#update_all"

  describe "GET#index" do
    context "with authenticated user" do
      #let(:current_user) { Fabricate(:user) }    
      #
      #before do
      #  session[:user_id] = current_user.id
      #end  
      it "set @my_queues associated with current_user" do            
        #current_user.my_queues << Fabricate(:my_queue, video: )
        set_current_user
        video = Fabricate(:video)
        my_queue_1 = Fabricate(:my_queue, user: current_user, video: video, list_order: 1)
        my_queue_2 = Fabricate(:my_queue, user: current_user, video: video, list_order: 2)
        get :index
        #expect(assigns(:my_queues)).to match_array(current_user.my_queues)
        expect(assigns(:my_queues)).to match_array([my_queue_1,my_queue_2])
      end
  
      it "render template :index" do
        set_current_user
        get :index
        expect(response).to render_template(:index)
      end
    end # End context "authenticated user" 

    context "with unauthenticaed user" do      
      #--->
      # refactor with the "shared_examples technique."
      #it "redirect_to signin_path" do
      #  get :index
      #  expect(response).to redirect_to(signin_path)
      #end
      #--->
      it_behaves_like "requires sign in" do
        let(:action) { get :index }
      end
      #--->
    end # End context "unauthenticaed user" 
  end # End describe "GET#index"

  describe "Post#create" do
    context "with authenticated user" do       
      #let(:current_user) { Fabricate(:user) }    
      let(:video) { Fabricate(:video) }      
      #before do
      #  session[:user_id] = current_user.id        
      #end

      it "redirect_to my_queues_path" do       
        set_current_user 
        post :create, video: video.id
        expect(response).to redirect_to(my_queues_path)
      end

      it "create the my_queue assoicated with the video & current_user" do
        user_Mary = Fabricate(:user)
        set_current_user(user_Mary)
        post :create, video: video.id
        #expect(current_user.my_queues.first.video).to eq(video)
        expect(MyQueue.first.user).to eq(user_Mary)
      end

      it "puts the last one position in the queue" do
        user_Mary = Fabricate(:user)
        set_current_user(user_Mary)
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
        set_current_user
        post :create, video: video.id        
        post :create, video: video.id
        post :create, video: video.id
        expect(current_user.my_queues.count).to eq(1)
      end
    end # End context "authenticated user" 

    context "unauthenticated user" do
      #--->
      #it "redirect_to the signin_path for unauthenticaed user" do        
        #video = Fabricate(:video)        
        #post :create, video: video.id
        #expect(response).to redirect_to(signin_path)           
      #end 
      #--->
      it_behaves_like "requires sign in" do
        let(:video) { video = Fabricate(:video) }
        let(:action) { post :create, video: video.id }
      end
      #---> 
    end # End context "unauthenticated user"    
  end # End describe "Post#create"

  describe "DELETE#destroy" do    
    context "authenticated user" do      
      #let(:current_user) { Fabricate(:user) }    
      #before do
      #  session[:user_id] = current_user.id
      #end
      it "redirect_to my_queues_path" do
        set_current_user
        video = Fabricate(:video)      
        my_queue = Fabricate(:my_queue, video: video, user: current_user, list_order: 1)
        delete :destroy, id: my_queue.id
        expect(response).to redirect_to(my_queues_path) 
      end

      it "delete one of current_user's my_queue according the params[:id]" do
        set_current_user
        video = Fabricate(:video)
        post :create, video: video
        expect(current_user.my_queues.count).to eq(1)        
        delete :destroy, id: current_user.my_queues.first.id
        expect(current_user.my_queues.count).to eq(0)
      end

      it "doesn't delete the my_queue which is not belonging to the current_user" do
        set_current_user
        video = Fabricate(:video)
        user = Fabricate(:user)
        my_queue = Fabricate(:my_queue, video: video, user: user, list_order: 1)        
        delete :destroy, id: my_queue.id
        expect(user.my_queues.first).to eq(my_queue)        
      end

      it "normalize the remaining my_queue items" do
        set_current_user
        video = Fabricate(:video)                
        my_queue_1 = Fabricate(:my_queue, video: video, user: current_user, list_order: 1)
        my_queue_2 = Fabricate(:my_queue, video: video, user: current_user, list_order: 2)
        delete :destroy, id: my_queue_1.id
        expect(my_queue_2.reload.list_order).to eq(1)        
      end
    end # End context "authenticated user" 

    context "unauthenticated user" do    
      #it "redirect_to the signin_path for unauthenticaed user" do                          
      #  video = Fabricate(:video)
      #  delete :destroy, id: video.id
      #  expect(response).to redirect_to(signin_path)   
      #end

      it_behaves_like "requires sign in" do 
        let(:video) {  Fabricate(:video) }
        let(:action) { delete :destroy, id: video.id}
      end
    end  # End context "unauthenticated user" 
  end # End describe "DELETE#destroy"
end

