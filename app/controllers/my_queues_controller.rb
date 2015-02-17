class MyQueuesController < ApplicationController
  
  before_action :require_sign_in

  def index 
    @my_queues = current_user.my_queues
  end

  def create    
    video = Video.find(params[:video])     
    #(current_user.my_queues << my_queue) unless MyQueue.where(video: video, user: current_user).count > 0      
    #(current_user.my_queues << my_queue) unless current_user.my_queues.map(&:video).include?(video)
    add_queue_video(video)
    redirect_to my_queues_path
  end

  def destroy        
    my_queue = MyQueue.find(params[:id]) 
    my_queue.delete if current_user.my_queues.include? my_queue     
    redirect_to my_queues_path    
  end

  private
  def new_list_order            
     my_queue = current_user.my_queues.order("list_order DESC").first
    if current_user.my_queues.order("list_order DESC").first.nil?       
      1
    else      
      my_queue.list_order.to_i + 1
    end
  end

  def is_added_into_current_user_my_queues?(video) 
    current_user.my_queues.map(&:video).include?(video)
  end

  def add_queue_video(video)
    my_queue = MyQueue.new(user: current_user, video: video, list_order: new_list_order)
    (current_user.my_queues << my_queue) unless is_added_into_current_user_my_queues? video 
  end
end