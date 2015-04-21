##-->
#class Admin::VideosController < ApplicationController
#  # These two filters have much dependency relationship
#  before_action :require_sign_in
#  before_action :require_admin
#  #-->
# refactory by inheritancing 'AdminedController'
class Admin::VideosController < AdminedController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    
    if @video.save
      flash[:success] = "Successfully created the video."
      redirect_to new_admin_video_path
    else
      flash[:error] = "Woops! Fail to create the video."
      render :new
    end
  end

  private
  def video_params
    params.require(:video).permit %i(title category_id description big_cover small_cover video_url)
  end
end