class User < ApplicationRecord
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy

  before_save :downcase_email

  SIGNUP_ATTRS = %i(name email password password_confirmation).freeze
  attr_accessor :remember_token

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

  has_secure_password

  class << self
    # Returns the hash digest of the given string.
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    # Returns a random token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Remembers a user in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  private

  # Converts email to all lower-case
  def downcase_email
    email.downcase
  end
end
