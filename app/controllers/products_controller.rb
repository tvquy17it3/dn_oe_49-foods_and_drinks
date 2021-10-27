class ProductsController < ApplicationController
  before_action :load_product, only: :show

  def show; end

  private

  def load_product
    @product = Product.find_by(id: params[:id])
    return if @product

    flash[:danger] = t "show_product_fail"
    redirect_to root_url
  end
end
