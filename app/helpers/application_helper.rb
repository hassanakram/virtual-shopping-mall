module ApplicationHelper
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(
        content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
          concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
          concat message
        end
      )
    end
    nil
  end

  def authorised_owner(user_id)
    user_signed_in? && current_user.id == user_id
  end

  def full_name(user)
    [user.first_name, user.last_name].join(" ")
  end

  def render_title(title)
    title.present? ? title.titleize : ""
  end

  def render_short_description(description)
    description.present? ? description.truncate(50) : ""
  end

  def product_image(product)
    if product.images.present?
      image_tag product.images.first.photo.url(:thumb)
    else
      image_tag("sample_product.gif")
    end
  end

  def user_image(user)
    user.image.present? ? image_tag(user.image.photo.url(:thumb)) : image_tag("missing.png")
  end

  def added_to_cart?(product_id)
    cookies["cart_items"].present? ? cookies["cart_items"].include?(product_id) : false
  end

end
