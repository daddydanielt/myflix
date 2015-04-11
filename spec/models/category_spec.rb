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
  it { should have_many(:recent_videos) }
  it { should have_many(:videos) }


  it "returns empty array if there's no any video at all" do
    #ex-1
    #Fabricate(:category, title:"title-custom")
    
    #ex-2
    #Fabricate(:category) do
    #  videos(count: 1) { |attrs, i| Fabricate(:video, title: "video_title_#{i}", description: "video_description_#{i}") }
    #end
    
    expect(Category.recent_videos.size).to eq(0)
    expect(Category.recent_videos).to eq([])
  end

  it "returns at most 6 recently videos, order by created_at desc, in all videos." do
    v0 = Fabricate(:video, title:"1-I am funny", description:"0 funny")
    v1 = Fabricate(:video, title:"1-I am funny", description:"1 funny")
    v2 = Fabricate(:video, title:"2-I am funny", description:"2 funny")
    v3 = Fabricate(:video, title:"3-I am funny", description:"3 funny")
    v4 = Fabricate(:video, title:"4-I am funny", description:"4 funny")
    v5 = Fabricate(:video, title:"5-I am funny", description:"5 funny")
    v6 = Fabricate(:video, title:"6-I am funny", description:"6 funny")
    v7 = Fabricate(:video, title:"7-I am funny", description:"7 funny")
    expect(Category.recent_videos).to eq([v7,v6,v5,v4,v3,v2])
    expect(Category.recent_videos.size).to eq(6)
    4.times { Video.first.destroy }
    expect(Category.recent_videos).to eq([v7,v6,v5,v4])
    expect(Category.recent_videos.count).to eq(4)
  end

  it "returns at most 6 videos which they are the most recently created videos according one specific Category." do
    #c = Category.create(title:"Funny")
    #c2 = Category.create(title:"Cool")
    #v1 = Video.create(title:"1-I am funny", description:"1 funny", category: c )
    #v2 = Video.create(title:"2-I am funny", description:"2 funny", category: c )
    #v3 = Video.create(title:"3-I am funny", description:"3 funny", category: c )
    #v4 = Video.create(title:"4-I am funny", description:"4 funny", category: c )
    #v5 = Video.create(title:"5-I am funny", description:"5 funny", category: c )
    #v6 = Video.create(title:"6-I am funny", description:"6 funny", category: c )
    #v7 = Video.create(title:"7-I am funny", description:"7 funny", category: c )
    #v8 = Video.create(title:"8-I am funny", description:"8 funny", category: c2 )
    #v9 = Video.create(title:"9-I am funny", description:"9 funny", category: c2 )
    c1 = Fabricate(:category, title:"Funny")
    c2 = Fabricate(:category, title:"Cool")
    v1 = Fabricate(:video, title:"1-I am funny", description:"1 funny", category: c1 )
    v2 = Fabricate(:video, title:"2-I am funny", description:"2 funny", category: c1 )
    v3 = Fabricate(:video, title:"3-I am funny", description:"3 funny", category: c1 )
    v4 = Fabricate(:video, title:"4-I am funny", description:"4 funny", category: c1 )
    v5 = Fabricate(:video, title:"5-I am funny", description:"5 funny", category: c1 )
    v6 = Fabricate(:video, title:"6-I am funny", description:"6 funny", category: c1 )
    v7 = Fabricate(:video, title:"7-I am funny", description:"7 funny", category: c1 )
    v8 = Fabricate(:video, title:"8-I am funny", description:"8 funny", category: c2 )
    v9 = Fabricate(:video, title:"9-I am funny", description:"9 funny", category: c2 )
    expect(Category.first.recent_videos).to eq([v7,v6,v5,v4,v3,v2])
  end

end


#  describe "TDD test" do
#    #condition: 0(empty),1,many,boundary(at least/at most/equal number)
#    #example:
#    #it "display the name when there's no tags"
#    #it "display the only tag with word 'tag' when there's one tag"
#    #it "display name with multiple tags"
#    #it "display up to four tags"
#    # lazy -evaluation
#    let(:subject) { Category.recent_videos }
#    # immediately create
#    let!(:subject) { Category.recent_videos }
#    # the same as
#    subject-2 { Category.recent_videos }
#
#
#    context "test-1: you can outline a title" do
#      before to
#        v0 = Video.create(title:"1-I am funny", description:"0 funny")
#        v1 = Video.create(title:"1-I am funny", description:"1 funny")
#        v2 = Video.create(title:"2-I am funny", description:"2 funny")
#        v3 = Video.create(title:"3-I am funny", description:"3 funny")
#        v4 = Video.create(title:"4-I am funny", description:"4 funny")
#        v5 = Video.create(title:"5-I am funny", description:"5 funny")
#        v6 = Video.create(title:"6-I am funny", description:"6 funny")
#        v7 = Video.create(title:"7-I am funny", description:"7 funny")
#      end
#      it "tes t-1" do
#        expect(su bject).to eq([v7,v6,v5,v4,v3,v2])
#        expect(subject.size).to eq(6)
#      end
#    end
#
#    context "text-2 " do
#      #it { expect(subject.recent_videos).to eq([]) }
#      it { should == [] }
#    end
#  end



