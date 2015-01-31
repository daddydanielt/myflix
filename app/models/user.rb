class User < ActiveRecord::Base

  has_secure_password validations: false #supress the default validations

  validates :email, presence: true, uniqueness: true, on: :create
  validates :password, presence: true, length: {minimum: 3}, on: :create
  validates :full_name, presence: true, on: :create  
  #validates_presence_of
  #validates_uniqueness_of
  
end