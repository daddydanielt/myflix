class User < ActiveRecord::Base

  has_secure_password validations: false #supress the default validations, use custom validation

  validates :email, presence: true, uniqueness: true, on: :create
  validates :password, presence: true, length: {minimum: 3}, on: :create
  validates :full_name, presence: true, on: :create  
  has_many :reviews
  
  has_many :my_queues

  #validates_presence_of
  #validates_uniqueness_of
  
end