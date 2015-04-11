module ApplicationHelper
  
  def my_form_for(record, options = {}, &block)
    form_for(record, options.merge( { builder: MyFormBuilder } ), &block)
  end

  def options_for_video_review(selected = nil)
    options_for_select( (1..5).to_a.map{ |n| [pluralize(n, "Star"),n] }, selected )
  end

end
