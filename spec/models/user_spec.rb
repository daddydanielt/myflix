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

  #--->
  #it "generates a random token when the user is created" do
  #  mary = Fabricate(:user)
  #  expect(mary.token).to be_present
  #end
  #--->
  #it_behaves_like "generate token" do
  it_behaves_like "tokenable" do
    let(:token) { Fabricate(:user).token }
  end
  #--->

  describe "#is_my_queue_video?" do
    it "returns true if the user has already queued this video." do
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

  describe "#follow" do
    it "follows another user" do
      bob = Fabricate(:user)
      alice = Fabricate(:user)
      bob.follow(alice)
      expect(bob.the_users_i_following).to include(alice)
    end

    it  "doesn't follow oneself" do
      alice = Fabricate(:user)
      alice.follow(alice)
      expect(alice.the_users_i_following).not_to include(alice)
    end

    it "doesn't follow the same user twice above" do
      alice = Fabricate(:user)
      another_user = Fabricate(:user)
      alice.follow(another_user)
      alice.follow(another_user)
      expect(alice.the_users_i_following.count).to eq(1)
    end
  end

  describe "#follow?" do
    it "return true if the user has already follow the another_user" do
      alice = Fabricate(:user)
      another_user = Fabricate(:user)
      alice.follow(another_user)
      expect(alice.follow?(another_user)).to be_truthy
    end

    it "return false if the user doesn't follow the another_user" do
      alice = Fabricate(:user)
      another_user = Fabricate(:user)
      expect(alice.follow?(another_user)).to be_falsey
    end
  end
  
end