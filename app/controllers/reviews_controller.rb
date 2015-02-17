class ReviewsController < ApplicationController
  
  before_action :require_sign_in

  def create    

    @video = Video.find( params[:video_id] )     
    #@review = Review.new( review_params.merge video:@video, user: current_user )    
    #@review = @video.reviews.create(review_params.merge video:@video, user: current_user )
    #review = @video.reviews.new(review_params.merge video:@video, user: current_user )
    review = @video.reviews.build(review_params.merge video:@video, user: current_user )
    
    #if @review.valid? 
    if review.save
      redirect_to video_path( @video ) 
    else
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
    #if @review.save 
    #  flash[:notice] = "You've created one review."
    #else
    #  flash[:notice] = "Fail to create review."
    #end        
  end

  private   
  def review_params     
    params.require(:review).permit(:rating, :content)
  end
end