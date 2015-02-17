class VideosController < ApplicationController
  before_action :require_sign_in

  def index        
    @categories = Category.all
  end

  def show    
    @video = Video.find_by(id: params[:id])    
    @reviews = @video.reviews        
    if !@video
      flash[:notice] = "There's no this video."
      redirect_to home_path    
    end
  end

  def search    
    @videos = Video.search_by_title(params[:search_pattern])           
  end

  def new    
    @video = Video.new  
  end

  def create

    mass_assignment_attributes = video_params
    @video =  Video.new( mass_assignment_attributes )

    if @video.save 
      flash[:notice] = "You've added one video."
      redirect_to video_path(@video)
    else
      render :new
    end
  end

  

  private 
  def video_params
    params.require(:video).permit(:title, :description)
  end
end