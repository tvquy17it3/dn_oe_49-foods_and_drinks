module UsersHelper
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("pages.edit_user.please_log_in")
    redirect_to login_url
  end
end
