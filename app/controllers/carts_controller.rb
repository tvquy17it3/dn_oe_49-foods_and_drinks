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
    if @quantity.positive?
      if check_condition
        @quantity = session[:cart][@product_id.to_s] + @quantity
        check_quantity
      end
    else
      @quantity = 1
    end
    session[:cart][@product_id.to_s] = @quantity
    redirect_back(fallback_location: carts_path)
  end

  def destroy
    id = params[:id].to_i
    session[:cart].delete(id.to_s)
    redirect_to carts_path
  end

  private

  def load_product
    @product = Product.find_by id: params[:product_id]
    return if @product

    flash[:danger] = t "show_product_fail"
    redirect_to root_path
  end

  def check_quantity
    return unless @quantity > @product.quantity

    @quantity = @product.quantity
  end

  def check_condition
    session[:cart].key?(@product_id.to_s)
  end

  def total_money arr
    arr.reduce(0) do |sum, item|
      sum + session[:cart][item.id.to_s] * item.price
    end
  end
end
