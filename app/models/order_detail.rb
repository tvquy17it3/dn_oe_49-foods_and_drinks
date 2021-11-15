class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product
  delegate :name, :thumbnail, to: :product, prefix: true

  validates :price, presence: true,
    numericality:
    {
      only_integer: false,
      greater_than_or_equal_to: Settings.init_number
    }
  validates :quantity, presence: true,
    numericality:
    {
      only_integer: true,
      greater_than_or_equal_to: Settings.rspec.quantity_1
    }
end
