class Admin::OrdersController < Admin::AdminsController
  before_action :load_order_details, only: %i(show update)

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
  end

  def update
    if check_status? params[:status]
      if @order.update(status: params[:status])
        UserMailer.order_status(@order, @order_details, @total).deliver_now
        flash[:success] = t "orders.order_changed"
      else
        flash[:danger] = t "orders.update_fail"
      end
    else
      flash[:success] = t "error_path"
    end

    redirect_back(fallback_location: admin_orders_path)
  end

  private

  # load order, order details, total price
  def load_order_details
    @order = Order.find_by(id: params[:id])
    if @order
      @order_details = @order.order_details.includes(:product)
      @total = total_order @order_details
    else
      flash[:danger] = t "orders.no_order"
      redirect_to admin_orders_path
    end
  end

  def load_orders status
    if check_status? status
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

  # check param status exists in the enum model order
  def check_status? status
    Order.statuses.include?(status)
  end
end
