class Admin::OrdersController < Admin::AdminsController
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

  private

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
end
