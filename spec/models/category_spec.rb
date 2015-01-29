require 'spec_helper'

describe Category do 
  
  #it "has many videos" do
  #  c = Category.create(title:"Funny")
  #  v1 = Video.create(title:"I am funny", description:"1 funny", category: c)
  #  v2 = Video.create(title:"I am funny funny", description:"2 funny", category: c)
  #  v3 = Video.create(title:"I am funny funny funny", description:"3 funny", category: c)      
  #  #expect(c.videos).to include(v1,v2,v3)
  #  expect(c.videos).to eq([v1,v2,v3])
  #end
  
  it "returns empty array if there's no any video at all" do
    expect(Category.recent_videos.size).to eq(0)
    expect(Category.recent_videos).to eq([])
  end

  it "returns at most 6 recently videos, order by created_at desc, in all videos." do
    
    v0 = Video.create(title:"1-I am funny", description:"0 funny")
    v1 = Video.create(title:"1-I am funny", description:"1 funny")
    v2 = Video.create(title:"2-I am funny", description:"2 funny")
    v3 = Video.create(title:"3-I am funny", description:"3 funny")
    v4 = Video.create(title:"4-I am funny", description:"4 funny")
    v5 = Video.create(title:"5-I am funny", description:"5 funny")
    v6 = Video.create(title:"6-I am funny", description:"6 funny")
    v7 = Video.create(title:"7-I am funny", description:"7 funny")

    expect(Category.recent_videos).to eq([v7,v6,v5,v4,v3,v2])
    expect(Category.recent_videos.size).to eq(6)

    4.times { Video.first.destroy } 

    expect(Category.recent_videos).to eq([v7,v6,v5,v4])    
    expect(Category.recent_videos.count).to eq(4)    
  end

  it "returns at most 6 videos which they are the most recently created videos according one specific Category." do
    c = Category.create(title:"Funny")
    c2 = Category.create(title:"Cool")
    v1 = Video.create(title:"1-I am funny", description:"1 funny", category: c )
    v2 = Video.create(title:"2-I am funny", description:"2 funny", category: c)
    v3 = Video.create(title:"3-I am funny", description:"3 funny", category: c )
    v4 = Video.create(title:"4-I am funny", description:"4 funny", category: c )
    v5 = Video.create(title:"5-I am funny", description:"5 funny", category: c )
    v6 = Video.create(title:"6-I am funny", description:"6 funny", category: c )
    v7 = Video.create(title:"7-I am funny", description:"7 funny", category: c )
    v8 = Video.create(title:"8-I am funny", description:"8 funny", category: c2 )
    v9 = Video.create(title:"9-I am funny", description:"9 funny", category: c2 )
    expect(Category.first.recent_videos).to eq([v7,v6,v5,v4,v3,v2])
  end

  it { should have_many(:recent_videos) } 
  it { should have_many(:videos) } 
end