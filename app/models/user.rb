class User < ActiveRecord::Base

  has_secure_password validations: false #supress the default validations, use custom validation

  validates :email, presence: true, uniqueness: true, on: :create
  validates :password, presence: true, length: {minimum: 3}, on: :create
  validates :full_name, presence: true, on: :create  
  has_many :reviews
  
  has_many :my_queues, -> { order "list_order ASC, updated_at ASC" }

  #validates_presence_of
  #validates_uniqueness_of

  def normalize_my_queue_list_orders
    my_queues.each_with_index do |my_queue,index|
      if my_queue.list_order != (index + 1)
        my_queue.list_order = (index + 1) 
        my_queue.save        
      end
    end
  end
end