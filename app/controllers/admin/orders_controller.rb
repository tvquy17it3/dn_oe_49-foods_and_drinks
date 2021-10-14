class Admin::OrdersController < Admin::AdminsController
  before_action :load_order, only: :show

  def index
    @title = t "orders.all"
    @orders = Order.includes(:order_details, :user)
                   .recent_orders.page(params[:page])
                   .per(Settings.show_10)
  end

  def index_by_status
    @title = t "status_order.#{params[:status]}"
    load_orders params[:status]
  end

  def show
    @title = t "orders.order_detail"
    @order_details = @order.order_details.includes(:product)
    @total = total_order @order_details
  end

  private

  def load_order
    @order = Order.find_by(id: params[:id])
    return if @order

    flash[:danger] = t "orders.no_order"
    redirect_to admin_orders_path
  end

  def load_orders status
    if Order.statuses.include?(status)
      @orders = Order.send(status)
                     .includes(:order_details, :user)
                     .recent_orders.page(params[:page])
                     .per(Settings.show_10)
      render :index
    else
      flash[:success] = t "error_path"
      redirect_to admin_orders_path
    end
  end

  def total_order order_details
    order_details.reduce(0) do |total, order|
      total + order.quantity * order.price
    end
  end
end
