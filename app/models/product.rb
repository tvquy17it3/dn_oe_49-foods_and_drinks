class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details
  scope :recent_products, ->{order created_at: :desc}
  delegate :name, to: :category, prefix: true
end
