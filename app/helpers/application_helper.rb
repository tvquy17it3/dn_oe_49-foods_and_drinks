module ApplicationHelper
  def full_title page_title = ""
    base_title = t "food_drink"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def show_message_for_field obj, attribute
    full_messages_for = obj.errors.full_messages_for(attribute)
    return if full_messages_for.empty?

    content_tag :ul, class: "error error-style" do
      full_messages_for.map{|msg| concat(content_tag(:li, msg))}
    end
  end

  def link_to_add_fields name, cate, association
    new_object = cate.object.send(association).class.new
    id = new_object.object_id
    fields =
      cate.fields_for(association, new_object, child_index: id) do |builder|
        render(association.to_s.singularize + "_field", cate: builder)
      end
    link_to(name, "#", class: "add_fields",
      data: {id: id, fields: fields.gsub("\n", "")})
  end
end
