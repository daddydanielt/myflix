require 'spec_helper'

describe ReviewsController do
  let(:video) { Fabricate(:video) }
  
  #contexnt "with authenticated user"
  context "user has already signed in" do  
    let(:current_user) do 
        Fabricate(:user) 
    end
    before do         
      session[:user_id] = current_user.id
    end

    context "with valid inputs" do      
      before do
        review_attributes = Fabricate.attributes_for(:review)
        post :create, review: review_attributes, video_id: video.id
      end

      it "create a review" do                                
        expect(Review.count).to eq(1)
      end 

      it "create a review associated with the video" do
        #session[:user_id] = Fabricate(:user).id                        
        #expect(assigns(:review).video).to eq(video)
        expect(Review.first.video).to eq(video)
      end

      it "create a review associated with the signed in user" do
                              
        expect(Review.first.user).to eq(current_user)        
      end
      
      it "redirect to the video show page ( video_path(@video) )" do
        #session[:user_id] = Fabricate(:user).id                                  
        expect(response).to redirect_to( video_path(video) )  
      end
    end

    context "with unvalid input" do

      it "doesn't creaste a review" do        
        post :create, review: { rating:4 }, video_id: video.id      
        expect(Review.count).to eq(0)
        post :create, review: { content: 'This is a test with unvalid input' }, video_id: video.id      
        expect(Review.count).to eq(0)
        post :create, review: { rating:'', content: '' }, video_id: video.id      
        expect(Review.count).to eq(0)
      end
      it "render video/show template" do        
        post :create, review: { rating:'', content: ''}, video_id: video.id
        puts "test"
        expect(response).to render_template('videos/show')
      end

      it "set @video" do        
        post :create, review: { rating:'', content: ''}, video_id: video.id
        expect(assigns(:video)).to eq(video)        
      end

      it "set @reviews" do        
        review = Fabricate(:review, video: video)
        post :create, review: { rating:'', content: ''}, video_id: video.id        
        expect(assigns(:reviews)).to match_array( video.reviews )        
      end
    end
 
  end

  #contexnt "with unauthenticated user"
  context "user doesn't sign in" do
      it "redirect_to singin_path" do        
        post :create, review: { rating:'5', content: 'This ia a review content'}, video_id: video.id
        expect(response).to redirect_to(signin_path)
      end
  end
end