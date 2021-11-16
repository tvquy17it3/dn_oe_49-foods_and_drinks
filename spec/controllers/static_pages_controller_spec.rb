require "rails_helper"

RSpec.describe StaticPagesController, type: :controller do
  describe "GET #home" do
    let!(:product_1) {FactoryBot.create :product}
    let!(:product_2) {FactoryBot.create :product}
    before do
      get :home
    end

    it "assigns @products" do
        expect(assigns(:products)).to eq [product_2, product_1]
    end
    it "render home" do
      expect(subject).to render_template :home
    end
  end

  describe "Template" do
    it "render about" do
      get :about
      expect(response).to render_template :about
    end
    it "render blog" do
      get :blog
      expect(response).to render_template :blog
    end
    it "render contact" do
      get :contact
      expect(response).to render_template :contact
    end
  end
end
