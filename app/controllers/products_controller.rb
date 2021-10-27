class ProductsController < ApplicationController
  before_action :load_product, only: :show

  def index
    @products = Product.find_name(params[:name])

    if @products.empty?
      @products = Product
      flash.now[:danger] = t "menu_page.search_pro_nil"
    end

    @products = @products.enabled
                         .recent_products
                         .page(params[:page])
                         .per(Settings.per_page_16)
    render "static_pages/menu"
  end

  def show; end

  private

  def load_product
    @product = Product.find_by(id: params[:id])
    return if @product

    flash[:danger] = t "show_product_fail"
    redirect_to root_url
  end
end
