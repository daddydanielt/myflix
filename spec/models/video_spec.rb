require 'spec_helper'

describe Video do 
  
  #it "saves itself" do
  #  v = Video.new(title: "Rspec-Video-save iteself", description: "this is a test")
  #  v.save
  #  
  #  #-->
  #  #Video.find(v).title.should == "Rspec-Video-save iteself"
  #  #-->
  #  #Video.find(v).title.should eq("Rspec-Video-save iteself")
  #  #-->
  #  expect(Video.first).to eq(v)
  #  #--> 
  #end

  #it " belons to one Category" do
  #  c = Category.new(title: "Funny")
  #  v = Video.create(title:"I am funny", category: c)    
  #  expect(v.category).to eq(c)    
  #end
  
  #it "can't save without :title or :description" do
  #  v1 = Video.create(description: "I have no :title!")
  #  expect(Video.all.size).to eq(0)
  #  v2 = Video.create(description: "I have no :description!")
  #  expect(Video.all.size).to eq(0)
  #end

  it { should belong_to(:category) }
  it { validate_presence_of(:title) }
  it { validate_presence_of(:description) }


  it "Title can't be blank" do
    v = Video.create(description: "I have no title!")
    v.save
    expect(v.errors.full_messages).to eq(["Title can't be blank"])
  end
end
