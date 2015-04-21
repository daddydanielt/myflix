class MyQueuesController < ApplicationController
  
  before_action :require_sign_in

  def index
    @my_queues = current_user.my_queues
  end

  def create
    #video = Video.find(params[:video])
    video = Video.find_by_token(params[:video])
    #(current_user.my_queues << my_queue) unless MyQueue.where(video: video, user: current_user).count > 0
    #(current_user.my_queues << my_queue) unless current_user.my_queues.map(&:video).include?(video)
    add_queue_video(video)
    redirect_to my_queues_path
  end

  def destroy
    my_queue = MyQueue.find(params[:id])
    if current_user.my_queues.include? my_queue
      my_queue.delete
      current_user.normalize_my_queue_list_orders
    end
    redirect_to my_queues_path
  end

  def update_all
    begin
      update_my_queues
      current_user.normalize_my_queue_list_orders
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid list_order number."
    end

    redirect_to my_queues_path
  end

  private
  
  def update_my_queues
    ActiveRecord::Base.transaction do
      my_queues = params[:my_queues]
      if my_queues.presence
        my_queues.each do |my_queue_item|
          my_queue = MyQueue.find(my_queue_item[:id])
          if my_queue && my_queue.user == current_user
            my_queue.update!(list_order: my_queue_item[:list_order], rating:my_queue_item[:rating])
          end
        end
      end
    end
    
  end

  #-->
  #refacatory to model/user.rb
  #-->
  #def normalize_my_queue_list_orders
  #  current_user.my_queues.each_with_index do |my_queue,index|
  #    if my_queue.list_order != (index + 1)
  #      my_queue.list_order = (index + 1)
  #      my_queue.save
  #    end
  #  end
  #end
  #-->

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