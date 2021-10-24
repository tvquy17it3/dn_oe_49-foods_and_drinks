module CartsHelper
  def check_thumbnail? thum
    if thum.thumbnail.present?
      image_tag thum.thumbnail.variant(resize_to_limit: [80,80])
    else
      gravatar_for thum, size: Settings.size_80
    end
  end
end
