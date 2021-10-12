class StaticPagesController < ApplicationController
  include ProductsHelper

  def home
    @products =
      Product.enabled.recent_products.take(Settings.show.digit_8)
  end

  def about; end

  def blog; end

  def contact; end

  def cart; end
end
