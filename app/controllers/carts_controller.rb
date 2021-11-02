class CartsController < ApplicationController
  before_action :load_product, only: :create

  def index
    qtity = session[:cart]
    @carts = Product.find_products_cart(qtity.keys)
    @total = total_money @carts
  end

  def create
    @product_id = params[:product_id].to_i
    @quantity = params[:quantity].to_i
    if session[:cart].has_key?("#{@product_id}")
      session[:cart]["#{@product_id}"] += @quantity
      check_quantity
    else
      session[:cart]["#{@product_id}"] = @quantity
    end
    redirect_back(fallback_location: carts_path)
  end

  private

  def load_product
    @product = Product.find_by id: params[:product_id]
    return if @product

    flash[:danger] = t "show_product_fail"
    redirect_to root_path
  end

  def check_quantity
    return unless session[:cart]["#{@product_id}"] > @product.quantity

    session[:cart]["#{@product_id}"] = @product.quantity
  end

  def total_money arr
    arr.reduce(0) do |sum, item|
      sum + session[:cart]["#{item.id}"] * item.price
    end
  end
end
