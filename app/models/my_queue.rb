class MyQueue < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video

  #-->
  delegate :title, to: :video, prefix: :video
  #-->
  #def video_title
  #  video.title
  #end
  #-->
  
  def rating
    review = Review.where(video: video, user: user).first
    if review 
      review.rating
    else
      nil
    end
  end 

  def category_name
    #--->
    category.title
    #--->
    #video.category.title
    #--->
  end

end