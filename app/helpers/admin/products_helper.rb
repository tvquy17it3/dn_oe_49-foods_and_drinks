module Admin::ProductsHelper
  def gravatar_for product, options = {size: Settings.gravatar.size_80}
    gravatar_id = Digest::MD5.hexdigest(product.name.downcase)
    size = options[:size]
    gravatar_url =
      "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: product.name, class: "gravatar")
  end

  def check_image?
    @product.thumbnail.attached?
  end
end
