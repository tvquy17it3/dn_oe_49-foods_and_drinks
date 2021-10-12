module ProductsHelper
  def gravatar_for product, options = {size: Settings.length.max_250}
    gravatar_id = Digest::MD5.hexdigest(product.name.downcase)
    size = options[:size]
    gravatar_url =
      "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: product.name, class: "gravatar")
  end
end
