class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product
  delegate :name, :thumbnail, to: :product, prefix: true
end
