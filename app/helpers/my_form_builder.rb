class MyFormBuilder < ActionView::Helpers::FormBuilder
  # label(object_name, method, content_or_options = nil, options = nil, &block)
  def label(method, text = nil, options = {}, &block )
    error_msg = @object.errors[ method.to_sym ].join
    text = text || method.to_s.capitalize
    text += " " + @template.content_tag(:span, "#{error_msg}", class: "label-warning") unless error_msg.blank?
    super(method, text.html_safe, options, &block)
  end
end