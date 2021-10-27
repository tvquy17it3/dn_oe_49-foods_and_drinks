require "rails_helper"
include SessionsHelper

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    subject {get :new}

    context 'when user unlogged' do
      it "render new" do
        expect(subject).to render_template(:new)
      end
      it "not render different template" do
        expect(subject).to_not render_template(:show)
      end
    end

    context 'when user is logged' do
      it "redirect to the root_url" do
        user = FactoryBot.create :user
        log_in user
        expect(subject).to redirect_to root_url
      end
    end
  end

  describe "POST #create" do
    context "when valid params" do
      before do
        post :create, params: { user: {
          name: Faker::Name.name_with_middle,
          email: "test@example.com",
          password: "Hello@1234",
          password_confirmation: "Hello@1234"
        }}
      end
      it "redirect to the root_url" do
        expect(response).to redirect_to root_url
      end
      it "display flash" do
        expect(flash[:success]).to eq I18n.t("sign_up.message_sign_up_success")
      end
    end

    context "when invalid params" do
      before do
        post :create, params: { user: { name: "", email:"foo" }}
      end
      it "render new" do
        expect(response).to render_template :new
      end
      it "display flash" do
        expect(flash[:danger]).to eq I18n.t("sign_up.message_sign_up_fail")
      end
    end
  end
end
