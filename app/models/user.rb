class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :name, presence: true, length:
    {
      minimum: Settings.length.min_5,
      maximum: Settings.length.max_100
    }

  def all_orders
    orders.recent_orders
  end
end
