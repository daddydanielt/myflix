require 'spec_helper'

describe Video do 
  it "saves itself" do
    v = Video.new(title: "Rspec-Video-save iteself")
    v.save
    Video.find(v).title.should == "Rspec-Video-save iteself"
  end

end
