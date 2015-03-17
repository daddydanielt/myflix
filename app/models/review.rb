class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  #validates :rating, presence: true
  #validates :content, presence: true
  validates_presence_of :rating, :content  
  
end