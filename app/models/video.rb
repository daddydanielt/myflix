class Video < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  
  belongs_to :category

  #has_many :reviews
  has_many :reviews, -> { order "created_at DESC" }
  
  has_many :my_queues


  def self.search_by_title(search_pattern)
    
    #quote_search_pattern = search_pattern.gsub(/\\/, '\&\&').gsub(/'/, "''")     
    #Video.where("title LIKE %#{search_pattern}%")
    #where("title LIKE '%#{search_pattern}%'")
    
    #return [] if search_pattern.empty? or search_pattern.nil?
    return [] if search_pattern.blank?
    where("lower(title) LIKE ?", "%#{search_pattern.downcase}%").order("created_at DESC")
    
  end
end 