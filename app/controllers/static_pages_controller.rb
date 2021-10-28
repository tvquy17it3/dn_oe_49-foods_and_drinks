class StaticPagesController < ApplicationController
  include ProductsHelper
  before_action :categories_select_id_name, only: :home

  def home
    @products =
      Product.enabled.recent_products.take(Settings.show.digit_8)
  end

  def about; end

  def blog; end

  def contact; end

  def cart; end
end
