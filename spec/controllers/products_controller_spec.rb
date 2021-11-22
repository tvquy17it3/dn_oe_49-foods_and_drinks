require "rails_helper"

RSpec.describe ProductsController, type: :controller do
  describe "GET #index" do
    let!(:product_1) {FactoryBot.create :product}
    let!(:product_2) {FactoryBot.create :product}

    context "when  search name is valid" do
      before do
        get :index, params: {q: {name_cont: product_1.name}}
      end
      it "assigns @product" do
        expect(assigns(:products)).to eq [product_1]
      end
      it "render the template menu" do
        expect(response).to render_template "static_pages/menu"
      end
    end

    context "when search name is invalid" do
      before do
        get :index, params: {q: {name_cont: Settings.rspec.length_negative_1}}
      end
      it "display flash danger" do
        expect(flash[:danger]).to eq I18n.t("menu_page.search_pro_nil")
      end
      it "render the template menu" do
        expect(response).to render_template "static_pages/menu"
      end
    end

    context "when without input name" do
      before do
        get :index
      end
      it "assigns @products" do
        expect(assigns(:products)).to eq [product_2, product_1]
      end
      it "render the template menu" do
        expect(response).to render_template "static_pages/menu"
      end
    end
  end

  describe "GET #show" do
    let!(:product) {FactoryBot.create :product}

    context "when product exist" do
      before do
        get :show, params: {id: product.id}
      end
      it "assigns @product" do
        expect(assigns(:product)).to eq product
      end
      it "renders the show template" do
        expect(response).to render_template :show
      end
    end

    context "when product not found" do
      before do
        get :show, params: {id: Settings.rspec.length_negative_1}
      end
      it "display flash danger" do
        expect(flash[:danger]).to eq I18n.t("show_product_fail")
      end
      it "redirect to the root_url" do
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "GET #filter" do
    let!(:category_1) {FactoryBot.create :category}
    let!(:category_2) {FactoryBot.create :category}
    let!(:product_1) {FactoryBot.create :product, category_id: category_1.id}
    let!(:product_2) {FactoryBot.create :product, category_id: category_2.id}

    context "when valid category_id" do
      before do
        get :filter, params: {category_id: category_2.id}
      end
      it "assigns @products" do
        expect(assigns(:products)).to eq [product_2]
      end
      it "render the template menu" do
        expect(response).to render_template "static_pages/menu"
      end
    end

    context "when invalid category_id" do
      before do
        get :filter, params: {category_id: Settings.rspec.length_negative_1}
      end
      it "display flash danger" do
        expect(flash[:danger]).to eq I18n.t("menu_page.filter_category_nil")
      end
      it "render the template menu" do
        expect(response).to render_template "static_pages/menu"
      end
    end
  end
end
