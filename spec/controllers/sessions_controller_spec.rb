require "rails_helper"
include SessionsHelper

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    subject {get :new}

    context "when not logged in" do
      it "render new" do
        expect(subject).to render_template(:new)
      end
      it "not render different template" do
        expect(subject).to_not render_template(:show)
      end
    end

    context "when logged in" do
      it "redirect to the root_url" do
        user = FactoryBot.create :user
        log_in user
        expect(subject).to redirect_to root_url
      end
    end
  end

  describe "POST #create" do
    let!(:user) {FactoryBot.create :user}
    context "when logged in" do
      before do
        log_in user
        post :create
      end

      it "redirect to the root" do
        expect(response).to redirect_to root_url
      end
    end

    context "when correct password" do
      before do
        post :create,  params: {
          session: {email: user.email, password: user.password}
        }
      end

      it "redirect root" do
         expect(response).to redirect_to root_url
      end
    end

    context "when correct password and remember" do
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

  describe "DELETE #destroy" do
    context "when not logged in" do
      before do
        delete :destroy
      end

      it "redirect to root" do
        expect(response).to redirect_to root_url
      end
    end

    context "when logged in" do
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
end
