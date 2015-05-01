class VideoDecorator < Draper::Decorator
  delegate_all
  
  def rating
    # object is the decorated object that you pass into the VideoDecorator.
    #if object.rating
    #   "#{object.rating}/5.0"
    #else
    #  "N/A"
    #end
    object.rating ? "#{object.rating}/5.0" : "N/A"
  end
end