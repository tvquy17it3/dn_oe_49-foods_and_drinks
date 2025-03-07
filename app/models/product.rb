class Product < ApplicationRecord
  belongs_to :category

  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details

  has_one_attached :thumbnail
  has_many_attached :images

  accepts_nested_attributes_for :category, allow_destroy: true,
                                           reject_if: :validate_nested

  scope :recent_products, ->{order created_at: :desc}

  enum status: {disabled: 0, enabled: 1}

  delegate :name, to: :category, prefix: true

  validates :category, presence: true

  validates :name, presence: true,
    length: {
      minimum: Settings.length.min_5,
      maximum: Settings.length.max_250
    }

  validates :price, presence: true, numericality: true

  validates :description, presence: true,
    length: {
      minimum: Settings.length.min_5,
      maximum: Settings.length.max_250
    }

  validates :quantity, presence: true, numericality: {only_integer: true}

  validates :images,
            content_type:
            {
              in: Settings.image.format,
              message: I18n.t("validate_image.msg_format")
            },
            size:
            {
              less_than: Settings.image.size_1mb.megabytes,
              message: I18n.t("validate_image.msg_size")
            }

  def display_image input
    images[input].variant(resize: Settings.resize_images).processed
  end

  def display_thumbnail
    thumbnail.variant(resize: Settings.resize_thumbnail).processed
  end

  def self.import file
    spreadsheet = Roo::Spreadsheet.open file
  rescue StandardError
    nil
  else
      arr = []
      header = spreadsheet.row(Settings.row_1)
      unless (header - self.column_names).empty?
        arr.push(I18n.t("validate_excel.model_fail"))
        return arr
      else
        (Settings.row_2..spreadsheet.last_row).each do |i|
          row = [header, spreadsheet.row(i)].transpose.to_h
          begin
            arr.push(i) unless create! row
          rescue ActiveRecord::RecordInvalid => e
            arr.push(I18n.t("validate_excel.row") + "#{i}  #{e.message}")
          end
          return arr if i == spreadsheet.last_row
        end
      end
  end

  private

  def validate_nested attribute
    return true if attribute[:name].blank?

    dem = 0
    Category.pluck(:name, :description).each do |item|
      if attribute[:name] == item[0] &&
        attribute[:description] == item[1]
          dem = 1
          break
      end
    end
    dem != 0
  end
end
