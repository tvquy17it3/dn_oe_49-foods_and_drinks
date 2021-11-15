class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :name, :description, presence: true,
    length: {
      minimum: Settings.length.min_2,
      maximum: Settings.length.max_250
    }
end
