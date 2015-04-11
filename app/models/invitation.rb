class Invitation < ActiveRecord::Base
  #--->
  #before_create :generate_token
  #--->
  include Tokenable_2
  #--->
  belongs_to :inviter, class_name: User
  validates :recipient_name, presence: true
  validates :recipient_email, presence: true

  def has_error?(key = nil)
    if key
      errors.messages.has_key? key
    else
      !errors.messages.empty?
    end
  end

  def error_message(key)
    errors.messages[key].join(",")
  end

  private
  #def generate_token
  #  self.token = SecureRandom.urlsafe_base64
  #end
end