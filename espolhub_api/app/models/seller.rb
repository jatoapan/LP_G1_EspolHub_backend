class Seller < ApplicationRecord
  has_secure_password

  # Constants
  VALID_FACULTIES = %w[FIEC FCNM FIMCP FIMCBOR FCSH FADCOM ESPAE FCV FICT].freeze

  # Associations
  has_many :announcements, dependent: :destroy
  has_many :refresh_tokens, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true,
                    uniqueness: true,
                    format: { with: /\A09\d{8}\z/, message: "debe ser un número ecuatoriano válido" }
  validates :faculty, presence: true,
                      inclusion: { in: VALID_FACULTIES, message: "no es una facultad válida" }
  validates :password, length: { minimum: 8 },
                       format: {
                         with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/,
                         message: "debe contener al menos una mayúscula, una minúscula y un número"
                       },
                       if: -> { new_record? || password.present? }

  # Callbacks
  before_save :normalize_email
  before_save :generate_whatsapp_link

  # Scopes
  scope :by_faculty, ->(faculty) { where(faculty: faculty) }
  scope :with_active_announcements, -> {
    joins(:announcements)
      .where(announcements: { status: 0 }) # 0 = active
      .distinct
  }
  scope :with_announcements, -> { includes(:announcements) }
  scope :by_announcements_count, -> { order(announcements_count: :desc) }

  private

  def normalize_email
    self.email = email.downcase.strip
  end

  def generate_whatsapp_link
    return if phone.blank?
    
    # Formato internacional para Ecuador (+593)
    international_phone = phone.gsub(/\A0/, "593")
    self.whatsapp_link = "https://wa.me/#{international_phone}"
  end
end