# app/models/announcement.rb
class Announcement < ApplicationRecord
  # Enums
  enum :condition, { new: "new", like_new: "like_new", good: "good", fair: "fair" }, prefix: true
  enum :status, { active: "active", sold: "sold", reserved: "reserved", inactive: "inactive" }, prefix: true

  # Associations
  belongs_to :seller
  belongs_to :category
  has_many_attached :images

  # Validations
  validates :title, presence: true, length: { minimum: 5, maximum: 150 }
  validates :description, length: { maximum: 2000 }
  validates :price, presence: true,
                    numericality: { greater_than: 0, less_than_or_equal_to: 100_000 }
  validates :condition, presence: true
  validates :status, presence: true
  validate :validate_images_count
  validate :validate_images_size

  # Callbacks
  after_create :process_images

  # Scopes
  scope :active_listings, -> { where(status: :active) }
  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :by_condition, ->(condition) { where(condition: condition) if condition.present? }
  scope :price_range, ->(min, max) {
    scope = all
    scope = scope.where("price >= ?", min) if min.present?
    scope = scope.where("price <= ?", max) if max.present?
    scope
  }
  scope :search, ->(query) {
    return all if query.blank?
    
    where("title ILIKE :q OR description ILIKE :q", q: "%#{sanitize_sql_like(query)}%")
  }
  scope :recent, -> { order(created_at: :desc) }
  scope :popular, -> { order(views_count: :desc) }

  # Constants
  MAX_IMAGES = 5
  MAX_IMAGE_SIZE = 5.megabytes
  VALID_IMAGE_TYPES = %w[image/jpeg image/png image/webp].freeze

  # Instance Methods
  def increment_views!
    increment!(:views_count)
  end

  def main_image_url
    return nil unless images.attached?
    
    Rails.application.routes.url_helpers.rails_blob_url(images.first, only_path: true)
  end

  def image_urls
    return [] unless images.attached?
    
    images.map do |image|
      Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
    end
  end

  def condition_label
    I18n.t("announcements.conditions.#{condition}")
  end

  def status_label
    I18n.t("announcements.statuses.#{status}")
  end

  private

  def validate_images_count
    return unless images.attached? && images.count > MAX_IMAGES
    
    errors.add(:images, "no puede tener más de #{MAX_IMAGES} imágenes")
  end

  def validate_images_size
    return unless images.attached?

    images.each do |image|
      if image.byte_size > MAX_IMAGE_SIZE
        errors.add(:images, "cada imagen debe ser menor a #{MAX_IMAGE_SIZE / 1.megabyte}MB")
        break
      end
      
      unless VALID_IMAGE_TYPES.include?(image.content_type)
        errors.add(:images, "solo se permiten imágenes JPEG, PNG o WebP")
        break
      end
    end
  end

  def process_images
    return unless images.attached?
    
    # Aquí podrías agregar procesamiento de imágenes (resize, optimize)
    # usando ActiveStorage variants
  end
end
