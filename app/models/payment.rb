class Payment < ActiveRecord::Base
  #--->
  #validates :user_id, presence: true, on: :create
  #validates :reference_id, presence: true, on: :create
  #--->
  validates_presence_of :user_id, :reference_id
  #--->
  belongs_to :user
end