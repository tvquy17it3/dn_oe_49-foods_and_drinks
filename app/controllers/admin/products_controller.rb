class Admin::ProductsController < Admin::AdminsController
  def index
    @products = Product.recent_products
                       .page(params[:page])
                       .per(Settings.per_page_15)
  end

  def show
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "show_product_fail"
    redirect_to admin_products_path
  end
end
