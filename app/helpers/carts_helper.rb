module CartsHelper
  def check_thumbnail? thum
    if thum.thumbnail.present?
      image_tag thum.thumbnail.variant(resize_to_limit:
        [Settings.gravatar.size_80, Settings.gravatar.size_80])
    else
      gravatar_for thum, size: Settings.gravatar.size_80
    end
  end
end
