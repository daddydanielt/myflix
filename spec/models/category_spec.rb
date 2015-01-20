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

  it { should have_many(:videos) } 
end
