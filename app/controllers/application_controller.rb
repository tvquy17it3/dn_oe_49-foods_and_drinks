class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_locale
  add_flash_types :info, :error, :warning

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_login"
    redirect_to login_url
  end
end
