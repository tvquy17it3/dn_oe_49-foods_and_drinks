module ApplicationHelper
  def full_title page_title = ""
    base_title = t "food_drink"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def show_message_for_field attribute
    full_messages_for = @user.errors.full_messages_for(attribute)
    return if full_messages_for.empty?

    content_tag :ul, class: "error" do
      full_messages_for.map{|msg| concat(content_tag(:li, msg))}
    end
  end
end
