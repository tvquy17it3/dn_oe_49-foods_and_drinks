module Admin::AdminsHelper
  def show_name
    current_user.name
  end

  def next_status status
    status = Order.statuses[status]
    case status
    when Settings.open
      :confirmed
    when Settings.confirmed
      :shipping
    when Settings.shipping
      :completed
    when Settings.completed
      :cancelled
    else
      :cancelled
    end
  end
end
