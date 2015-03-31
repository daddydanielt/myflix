require 'spec_helper'

describe Relationship do
  it { should belong_to( :following ) }
  it { should belong_to( :follower ) }
end