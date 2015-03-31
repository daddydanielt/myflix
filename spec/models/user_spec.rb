require 'spec_helper'

describe User do  
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }

  it { should validate_uniqueness_of(:email) }

  it { should have_many(:my_queues).order( "list_order ASC, updated_at ASC" ) }
  it { should have_many(:reviews).order( "created_at DESC" ) }

  it { should have_many(:following_relationships) }
  it { should have_many(:following_me_relationships) }

  describe "is_my_queue_video?" do
    it "returns true if the user has alread queued this video." do
      user = Fabricate(:user)
      video_1 = Fabricate(:video)
      my_queue = Fabricate(:my_queue, user: user, video: video_1, list_order: 1)            
      #user.is_my_queue_video?(video_1).should be_true
      user.is_my_queue_video?(video_1).should be_truthy
    end

    it "returns false if the user doesn't queue this video." do
      user = Fabricate(:user)
      video_1 = Fabricate(:video)
      video_2 = Fabricate(:video)
      my_queue = Fabricate(:my_queue, user: user, video: video_1, list_order: 1)      
      #user.is_my_queue_video?(video_2).should be_false
      user.is_my_queue_video?(video_2).should be_falsey
    end
  end
  
end