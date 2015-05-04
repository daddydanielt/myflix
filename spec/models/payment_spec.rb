require 'spec_helper'

describe Payment do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:reference_id) }
  it { should belong_to :user }
end