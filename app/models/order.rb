class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  delegate :name, to: :user, prefix: true
  enum status: {
    open: Settings.open,
    confirmed: Settings.confirmed,
    shipping: Settings.shipping,
    completed: Settings.completed,
    cancelled: Settings.cancelled
  }
  scope :recent_orders, ->{order created_at: :desc}
end
