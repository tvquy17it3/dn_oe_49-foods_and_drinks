require "rails_helper"
include SessionsHelper

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    subject {get :new}

    context "when user unlogged" do
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

  describe "GET #create" do
    let!(:user) {FactoryBot.create :user}

    context "when login correct password" do
      before do
        post :create,  params: {
          session: {email: user.email, password: user.password}
        }
      end

      it "redirect root" do
         expect(response).to redirect_to root_url
      end
    end

    context "when login correct password and remember" do
      before do
        post :create,  params: {
          session: {
            email: user.email,
            password: user.password,
            remember_me: Settings.show.digit_1
          }
        }
      end

      it "redirect root" do
         expect(response).to redirect_to root_url
      end
    end

    context "when login incorrect password" do
      before do
        post :create,  params: {
          session: {email: user.email, password: "foo"}
        }
      end

      it "dislay flash danger" do
        expect(flash[:danger]).to eq I18n.t("log_in.invalid_email_or_password")
      end
      it "render new" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #destroy" do
    let!(:user){FactoryBot.create :user}
    before do
      log_in user
      delete :destroy
    end

    it "redirect to root" do
      expect(response).to redirect_to root_url
    end
  end
end
