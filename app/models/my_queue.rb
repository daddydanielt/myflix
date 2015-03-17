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
  
  validates_numericality_of :list_order, only_integer: true ,on: [:create, :update]
  

  def rating
    #review = Review.where(video: video, user: user).first
    if review 
      review.rating
    else      
      nil
    end
  end 

  #( virtual attribute )
  def rating=(new_rating)
    #review = Review.where(video: video, user: user).first     
    #review.update_attributes(rating: new_rating) if review
    #review.update!(rating: new_rating) if review
    if review
      review.update_columns(rating: new_rating) 
    else
      # using Review.new instead of Review.create to avoid the Valitaion.      
      #--->
      #review = Review.new(user: user, video:video, rating: new_rating)      
      new_review = Review.new(user: user, video:video, rating: new_rating)      
      #review.save(validate: false)
      new_review.save(validate: false) #bypass validation     
      #---> 
    end
  end

  def category_name
    #--->
    category.title
    #--->
    #video.category.title
    #--->
  end

  private
  def review
    @review ||= Review.where(video: video, user: user).first    
  end
end