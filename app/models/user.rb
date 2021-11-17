class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy

  before_save :downcase_email

  SIGNUP_ATTRS = %i(name email password password_confirmation).freeze

  validates :name, presence: true, length:
    {
      minimum: Settings.length.min_5,
      maximum: Settings.length.max_100
    }
  validates :email, presence: true, uniqueness: true,
    length: {maximum: Settings.length.max_250},
    format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :password, presence: true, length:
    {
      minimum: Settings.length.min_8,
      maximum: Settings.length.max_100
    }, allow_nil: true

  def all_orders
    orders.recent_orders
  end

  private

  # Converts email to all lower-case
  def downcase_email
    email.downcase
  end
end
