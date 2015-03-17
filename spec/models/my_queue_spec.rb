require 'spec_helper'

describe MyQueue do
  it { should belong_to(:user) }
  it { should belong_to(:video) }  
  it { should validate_numericality_of(:list_order) }  

  describe "video_title" do
    it "returns the title of the associated video" do            
      video = Fabricate(:video, title: 'Monk')      
      my_queue = Fabricate(:my_queue, video: video, list_order: 1)
      expect(my_queue.video_title).to eq('Monk')
    end
  end

  describe "catgeory" do
    it "returns the category of the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      my_queue = Fabricate(:my_queue, user: user, video: video, list_order: 1)
      expect(my_queue.category).to eq(video.category)
    end
  end

  describe "rating" do
    it "returns the rating from the review when the review is present" do
      review = Fabricate( :review, video: Fabricate(:video), user: Fabricate(:user) )
      review.update(rating: 5)

      my_queue = Fabricate(:my_queue, video: review.video, user: review.user, list_order: 1)
      expect( my_queue.rating ).to eq( 5 )
    end

    it "returns the nil when the review is not present" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      user = Fabricate(:user)      
      my_queue = Fabricate(:my_queue, user: user, video: video, list_order: 1)
      expect( my_queue.category).to eq(category)
    end 
  end

  describe "rating=" do
    it "changes the rating of the view if the review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 1)
      my_queue = Fabricate(:my_queue, user: user, video: video, list_order: 1)      
      my_queue.rating = 5
      expect( my_queue.rating).to eq(5)
    end
    
    it "clear the rating of the view if the review is present" do
      user =  Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: user, video: video, rating: 1)
      my_queue = Fabricate(:my_queue, user: user, video: video, list_order: 1)
      my_queue.rating = nil      
      expect(review.reload.rating).to be_nil
    end

    it "create the review with the rating if the review is not present" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      
      #review = Fabricate(:review, user: user, video: video, rating: 1)
      my_queue = Fabricate(:my_queue, user: user, video: video, list_order: 1)
      my_queue.rating = 5
      expect( Review.first.rating).to eq(5)
    end
  end

  describe "category_name" do
    it "returns the category's name from the video" do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      user = Fabricate(:user)
      my_queue= Fabricate(:my_queue, video: video, user: user, list_order: 1)
      expect(my_queue.category_name).to eq(video.category.title)
    end    
  end
end