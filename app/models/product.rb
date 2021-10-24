class Product < ApplicationRecord
  belongs_to :category
  has_many_attached :images
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details
  enum status: {disabled: 0, enabled: 1}
  scope :recent_products, ->{order created_at: :desc}
  delegate :name, to: :category, prefix: true
end
