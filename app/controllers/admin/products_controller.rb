class Admin::ProductsController < Admin::AdminsController
  def index
    @products = Product.recent_products
                       .page(params[:page])
                       .per(Settings.per_page_15)
  end

  def import
    arr_message = import_data params[:file]
    if arr_message.empty?
      flash[:success] = t "product_controller.msg_import_success"
    else
      flash[:info] = arr_message
    end
    redirect_to admin_products_url
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

  def import_data file
    arr = []
    spreadsheet = Roo::Spreadsheet.open file
  rescue StandardError
    arr.push(I18n.t("validate_excel.format"))
    arr
  else
    header = spreadsheet.row(Settings.row_1)
    if (header - Product.column_names).any?
      arr.push(I18n.t("validate_excel.model_fail"))
      return arr
    else
      Product.handle_check spreadsheet, header, arr
    end
  end
end
