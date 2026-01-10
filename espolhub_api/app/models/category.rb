class Category < ApplicationRecord
  # === Associations ===
  has_many :announcements, dependent: :restrict_with_error

  # === Validations ===
  validates :name, presence: true,
    uniqueness: {case_sensitive: false},
    length: {minimum: 2, maximum: 50}

  # === Callbacks ===
  before_save :normalize_name

  # === Scopes ===
  scope :active, -> { where(active: true) }
  scope :alphabetical, -> { order(:name) }
  scope :with_announcements_count, -> {
    left_joins(:announcements)
      .where(announcements: {status: 0}) # 0 = active enum value
      .group(:id)
      .select("categories.*, COUNT(announcements.id) as active_announcements_count")
  }

  # === Instance Methods ===
  def to_s
    name
  end

  def active_announcements_count
    announcements.where(status: :active).count
  end

  private

  def normalize_name
    self.name = name.strip.capitalize if name.present?
  end
end
