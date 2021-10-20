class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :destroy
  scope :recent_products, ->{order created_at: :desc}
end
