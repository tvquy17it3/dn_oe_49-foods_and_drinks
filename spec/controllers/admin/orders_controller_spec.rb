require "rails_helper"
include SessionsHelper

RSpec.describe Admin::OrdersController, type: :controller do
  describe "GET #index" do
    let!(:user) {FactoryBot.create :user, role: false}
    context "when not logged in" do
      before do
        get :index, params: {locale: I18n.locale}
      end

      it "redirect to login" do
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "when logged in" do
      context "when not permission" do
        let!(:user) {FactoryBot.create :user, role: false}
        before do
          sign_in user
          get :index
        end

        it "display flash danger" do
          expect(flash[:danger]).to eq I18n.t("not_permission")
        end
        it "redirect to root_url" do
          expect(response).to redirect_to root_url
        end
      end

      describe "when has permission" do
        let!(:user) {FactoryBot.create :user, role: true}
        let!(:order_1) {FactoryBot.create :order}
        let!(:order_2) {FactoryBot.create :order}
        before do
          sign_in user
        end

        context "show order DESC" do
          let!(:user) {FactoryBot.create :user, role: true}
          let!(:order_1) {FactoryBot.create :order}
          let!(:order_2) {FactoryBot.create :order}
          before do
            get :index
          end

          it "assigns @orders" do
            expect(assigns(:orders)).to eq [order_2, order_1]
          end
          it "renders the template index" do
            expect(response).to render_template :index
          end
        end

        context "when search name is valid" do
          before do
            get :index, params: {q: {name_cont: order_2.name}}
          end

          it "assigns @orders" do
            expect(assigns(:orders)).to eq [order_2]
          end
          it "renders the template index" do
            expect(response).to render_template :index
          end
        end

        context "when search name is invalid" do
          before do
            get :index, params: {q: {name_cont: Settings.rspec.length_negative_1}}
          end

          it "assigns @orders" do
            expect(assigns(:orders)).to eq []
          end
          it "renders the template index" do
            expect(response).to render_template :index
          end
        end
      end
    end
  end

  describe "when logged in and has permission" do
    let(:user) {FactoryBot.create :user, role: true}
    before do
      sign_in user
    end

    describe "GET #index_by_status" do
      context "when order status invalid" do
        let!(:order_1) {FactoryBot.create :order}
        before do
          get :index_by_status, params: {status: Settings.rspec.length_negative_1}
        end

        it "display flash danger" do
          expect(flash[:success]).to eq I18n.t("error_path")
        end
        it "redirect to admin orders" do
          expect(response).to redirect_to admin_orders_path
        end
      end

      context "when order status valid" do
        let!(:order_1) {FactoryBot.create :order, status: :open}
        let!(:order_2) {FactoryBot.create :order, status: :cancelled}
        before do
          get :index_by_status, params: {status: :cancelled}
        end

        it "assigns @orders" do
          expect(assigns(:orders)).to eq [order_2]
        end
        it "renders the template index" do
          expect(response).to render_template :index
        end
      end
    end

    describe "GET #show" do
      let(:order) {FactoryBot.create :order, user_id: user.id}
      context "when order not found" do
        before do
          get :show, params: {id: Settings.rspec.length_negative_1}
        end

        it "display flash danger" do
          expect(flash[:danger]).to eq I18n.t("orders.no_order")
        end
        it "redirect to admin orders" do
          expect(response).to redirect_to admin_orders_path
        end
      end

      context "when order exist" do
        let!(:order_details) {FactoryBot.create :order_detail, order_id: order.id}
        before do
          get :show, params: {id: order.id}
        end

        it "assigns @order" do
          expect(assigns(:order)).to eq order
        end
        it "assigns  @order_details" do
          expect(assigns(:order_details)).to eq [order_details]
        end
        it "renders the template show" do
          expect(response).to render_template :show
        end
      end
    end

    describe "PUT #approve" do
      context "when order status open" do
        let(:order) {FactoryBot.create :order, status: :open}
        before do
          put :approve, params: {id: order.id}
        end

        it "display flash success" do
          expect(flash[:success]).to eq I18n.t("orders.approve_success")
        end
        it "redirect to admin orders" do
          expect(response).to redirect_to root_path
        end
      end

      context "when order status confirmed" do
        let(:order) {FactoryBot.create :order, status: :confirmed}
        before do
          put :approve, params: {id: order.id}
        end

        it "display flash danger" do
          expect(flash[:danger]).to eq I18n.t("orders.approve_failed")
        end
        it "redirect to root" do
          expect(response).to redirect_to root_path
        end
      end
    end

    describe "PUT #reject" do
      context "when order status open" do
        let(:order) {FactoryBot.create :order, status: :open}
        before do
          get :reject, params: {id: order.id}
        end

        it "display flash success" do
          expect(flash[:success]).to eq I18n.t("orders.reject_success")
        end
        it "redirect to admin orders" do
          expect(response).to redirect_to admin_orders_path
        end
      end

      context "when order status confirmed" do
        let(:order) {FactoryBot.create :order, status: :confirmed}
        before do
          get :reject, params: {id: order.id}
        end

        it "display flash success" do
          expect(flash[:success]).to eq I18n.t("orders.reject_success")
        end
        it "redirect to admin orders" do
          expect(response).to redirect_to admin_orders_path
        end
      end
    end

    describe "PUT #update" do
      context "when order status confirmed" do
        let(:order) {FactoryBot.create :order, status: :confirmed}
        before do
          put :update, params: {id: order.id}
        end

        it "display flash success" do
          expect(flash[:success]).to eq I18n.t("orders.order_changed")
        end
        it "redirect to admin orders" do
          expect(response).to redirect_to admin_orders_path
        end
      end

      context "when order status cancelled" do
        let(:order) {FactoryBot.create :order, status: :cancelled}
        before do
          put :update, params: {id: order.id}
        end

        it "display flash danger" do
          expect(flash[:danger]).to eq I18n.t("orders.update_fail")
        end
        it "redirect to admin orders" do
          expect(response).to redirect_to admin_orders_path
        end
      end
    end
  end
end
