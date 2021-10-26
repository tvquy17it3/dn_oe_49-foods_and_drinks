class Admin::ProductsController < Admin::AdminsController
  def index
    @products = Product.recent_products
                       .page(params[:page])
                       .per(Settings.per_page_15)
  end

  def import
    @products = Product.import params[:file]
    if @products
      if @products.present?
        flash[:info] = @products
        redirect_to admin_products_url
      end
    else
      flash[:danger] = t "product_controller.msg_import_failer"
      redirect_to new_admin_product_url
    end
  end

  def show
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "product_controller.msg_show_failer"
    redirect_to admin_products_path
  end

  def new
    @product = Product.new
    @product.build_category
  end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:info] = t "product_controller.msg_create_success"
      redirect_to admin_product_path(@product)
    else
      render :new
    end
  end

  private

  def product_params
    params.require(:product)
          .permit(:thumbnail, :name, :price, :description, :quantity, :status,
                  :category_id, images: [],
                  category_attributes: [:name, :description])
  end
end
