 class User < ActiveRecord::Base

  has_secure_password validations: false #supress the default validations, use custom validation

  validates :email, presence: true, uniqueness: true, on: :create
  validates :password, presence: true, length: {minimum: 3}, on: :create
  validates :full_name, presence: true, on: :create  
  
  has_many :my_queues, -> { order "list_order ASC, updated_at ASC" }
  has_many :reviews, -> { order "created_at DESC" }

  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :following_me_relationships, class_name: "Relationship", foreign_key: :following_id
  

  #validates_presence_of
  #validates_uniqueness_of
  def the_users_following_me
    following_me_relationships.map(&:follower)
  end

  def the_users_i_following
    following_relationships.map(&:following)
  end

  def normalize_my_queue_list_orders
    my_queues.each_with_index do |my_queue,index|
      if my_queue.list_order != (index + 1)
        my_queue.list_order = (index + 1) 
        my_queue.save        
      end
    end
  end

  def is_my_queue_video?( video )
    my_queues.map(&:video).include? video
  end
end