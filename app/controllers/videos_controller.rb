class VideosController < ApplicationController

  def index    
    @categories = Category.all
  end

  def show    
    @video = Video.find_by(id: params[:id])            
    if !@video
      flash[:notice] = "There's no this video."
      redirect_to home_path    
    end
  end
end