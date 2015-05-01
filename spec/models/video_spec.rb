require 'spec_helper'



describe Video do
  #--->
  it { should belong_to(:category) }
  it { should have_many(:reviews).order('created_at DESC') }
  it { should have_many(:my_queues) }
  it { should validate_presence_of :title}
  it { should validate_presence_of :description}
  it { should validate_presence_of(:category_id).on(:create) }
  #--->
  
  #--->
  #it "generates a random token when the video is created" do
  #  video = Fabricate(:video)
  #  expect(video.token).to be_present
  #end
  #--->
  #it_behaves_like "generate token" do
  it_behaves_like "tokenable" do
    let(:token) { Fabricate(:video).token }
  end
  
  #--->
  describe "#rating" do
    it "returns the average reviews' rating if there is any review associated to itself." do
      v1 = Fabricate(:video)
      v1.reviews << Fabricate(:review, rating: 5)
      v1.reviews << Fabricate(:review, rating: 1)
      expect(Video.last.rating).to eq(3)
    end
  end

  #--->
  describe "#search_by_title" do
    it "returns an empty array if there's no match" do
      category = Fabricate(:category)
      v1 = Video.create(category_id: category.id, title: "Futurama", description: "Space Travel")
      v2 = Video.create(category_id: category.id, title: "back_to_furture", description: "Time travel")
      expect(Video.search_by_title("Can't find any videos")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      category = Fabricate(:category)
      v1 = Video.create(category_id: category.id ,title: "Futurama", description: "Space Travel")
      v2 = Video.create(category_id: category.id ,title: "back_to_furture", description: "Time travel")
      expect(Video.search_by_title("Futurama")).to eq([v1])
    end

    it "returns an array of one video for a partial match" do
      category = Fabricate(:category)
      v1 = Video.create(category_id: category.id, title: "Futurama", description: "Space Travel")
      v2 = Video.create(category_id: category.id, title: "back_to_furture", description: "Time travel")
      expect( Video.search_by_title("Futu") ).to eq([v1])
    end
    
    it "returns an array of all matches ordered by :created_at" do
      category = Fabricate(:category)
      v1 = Video.create(category_id: category.id, title: "Futurama-1", description: "Space Travel")
      v2 = Video.create(category_id: category.id, title: "back_to_furture", description: "Time travel")
      v3 = Video.create(category_id: category.id, title: "Futurama-2", description: "Space Travel")
      expect( Video.search_by_title("Futu") ).to eq([v3,v1])
    end

    it "returns an empty array for a search with an empty string" do
      category = Fabricate(:category)
      v1 = Video.create(category_id: category.id, title: "Futurama-1", description: "Space Travel")
      v2 = Video.create(category_id: category.id, title: "back_to_furture", description: "Time travel")
      v3 = Video.create(category_id: category.id, title: "Futurama-2", description: "Space Travel")

      expect( Video.search_by_title("") ).to eq([])
      expect( Video.search_by_title("   ") ).to eq([])
      expect( Video.search_by_title(nil) ).to eq([])
    end
  end


end

###describe Video do
###  describe ".search_by_title" do
###
###
###    it "return empty array if it can't find any videos according search_pattern" do
###      v1 = Video.create(title: "family is the best important.", description: "good movie")
###      v2 = Video.create(title: "How many people are there in your family?", description: "1 or 2 or 3 or a lot.")
###      v3 = Video.create(title: "Good luck to you.", description: "everyone needs that.")
###      search_pattern ="you can't find me"
###      expect(Video.search_by_title(search_pattern)).to eq([])
###    end
###    it "return one array of videos according search_pattern" do
###      v1 = Video.create(title: "family is the best important.", description: "good movie")
###      v2 = Video.create(title: "How many people are there in your family?", description: "1 or 2 or 3 or a lot.")
###      v3 = Video.create(title: "Good luck to you.", description: "everyone needs that.")
###      search_pattern ="family"
###      expect(Video.search_by_title(search_pattern)).to eq([v1,v2])
###    end
###  end
###  #it "saves itself" do
###  #  v = Video.new(title: "Rspec-Video-save iteself", description: "this is a test")
###  #  v.save
###  #
###  #  #-->
###  #  #Video.find(v).title.should == "Rspec-Video-save iteself"
###  #  #-->
###  #  #Video.find(v).title.should eq("Rspec-Video-save iteself")
###  #  #-->
###  #  expect(Video.first).to eq(v)
###  #  #-->
###  #end
###
###  #it " belons to one Category" do
###  #  c = Category.new(title: "Funny")
###  #  v = Video.create(title:"I am funny", category: c)
###  #  expect(v.category).to eq(c)
###  #end
###
###  #it "can't save without :title or :description" do
###  #  v1 = Video.create(description: "I have no :title!")
###  #  expect(Video.all.size).to eq(0)
###  #  v2 = Video.create(description: "I have no :description!")
###  #  expect(Video.all.size).to eq(0)
###  #end
###
###  it { should belong_to(:category) }
###  it { validate_presence_of(:title) }
###  it { validate_presence_of(:description) }
###
###  it "Title can't be blank" do
###    v = Video.create(description: "I have no title!")
###    v.save
###    expect(v.errors.full_messages).to eq(["Title can't be blank"])
###  end
###end
###