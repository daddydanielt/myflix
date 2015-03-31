class Category < ActiveRecord::Base
  has_many :videos, -> { order :title }
  
  has_many :recent_videos, -> { order('created_at desc').limit(6) }, class_name: "Video"
  
  def self.recent_videos
    #Video.order("created_at desc").limit(6)
    Video.order("created_at desc").first(6)
  end
end