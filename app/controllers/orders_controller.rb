class OrdersController < ApplicationController
  before_action :logged_in_user

  def index
    @orders = current_user.all_orders
                          .page(params[:page])
                          .per(Settings.show_5)
  end

  def show; end
end
