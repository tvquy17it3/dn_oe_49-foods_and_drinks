class SessionsController < ApplicationController
  layout "signup_signin"

  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      check_activated user
    else
      flash.now[:danger] = t "log_in.invalid_email_or_password"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def check_activated user
    log_in user
    if params[:session][:remember_me] == Settings.show.digit_1
      remember(user)
    else
      forget(user)
    end
    redirect_to root_url
  end
end
