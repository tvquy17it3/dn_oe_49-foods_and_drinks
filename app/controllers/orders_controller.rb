class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :load_order, :load_order_details, only: :show

  def index
    @orders = current_user.all_orders
                          .page(params[:page])
                          .per(Settings.show_5)
  end

  def show; end

  private

  def load_order
    @order = current_user.orders.find_by(id: params[:id])
    return if @order

    flash[:danger] = t "orders.no_order"
    redirect_to admin_orders_path
  end

  def load_order_details
    @order_details = @order.order_details.includes(:product)
    @total = total_order @order_details
  end

  def total_order order_details
    order_details.reduce(0) do |total, order|
      total + order.quantity * order.price
    end
  end
end
