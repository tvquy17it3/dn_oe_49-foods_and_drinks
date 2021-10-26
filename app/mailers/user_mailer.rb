class UserMailer < ApplicationMailer
  # change status order and send mail
  def order_status order, order_details, total
    @order = order
    @order_details = order_details
    @total = total
    mail to: @order.user_email, subject: t("order_mailer.title.#{order.status}")
  end
end
