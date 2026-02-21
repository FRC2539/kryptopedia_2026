module ApplicationHelper
  def error_messages_for(object, field)
    content_tag(:div, class: "error") do
      object.errors.full_messages_for(field).map { |msg| content_tag(:p, msg) }.join.html_safe
    end if object.errors.any?
  end
end
