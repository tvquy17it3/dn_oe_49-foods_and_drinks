class Address < ApplicationRecord
  belongs_to :user

  delegate :name, :email, to: :user, prefix: true

  validates :name, :phone, :address, presence: true,
    length: {
      minimum: Settings.length.min_5,
      maximum: Settings.length.max_250
    }
end
