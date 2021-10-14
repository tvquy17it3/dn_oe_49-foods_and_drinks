class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :load_order, :load_order_details, only: %i(show cancel)

  def index
    @orders = current_user.all_orders
                          .page(params[:page])
                          .per(Settings.show_5)
  end

  def show; end

  def cancel
    if @order.open?
      @order.cancelled!
      send_mail
    else
      flash[:danger] = t "orders.update_fail"
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "orders.update_fail"
  else
    flash[:success] = t "orders.order_changed"
  ensure
    redirect_back(fallback_location: user_order_path)
  end

  private

  def load_order
    @order = current_user.orders.find_by(id: params[:id])
    return if @order

    flash[:danger] = t "orders.no_order"
    redirect_to root_path
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

  def send_mail
    UserMailer.order_status(@order, @order_details, @total).deliver_now
  end
end
