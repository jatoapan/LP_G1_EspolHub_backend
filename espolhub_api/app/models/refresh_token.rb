# frozen_string_literal: true

# Model for managing refresh tokens
# Stores hashed tokens to allow token revocation and tracking
class RefreshToken < ApplicationRecord
  # === Associations ===
  belongs_to :seller

  # === Validations ===
  validates :token_digest, presence: true
  validates :jti, presence: true, uniqueness: true
  validates :expires_at, presence: true

  # === Scopes ===
  scope :active, -> { where(revoked_at: nil).where('expires_at > ?', Time.current) }
  scope :expired, -> { where('expires_at <= ?', Time.current) }
  scope :revoked, -> { where.not(revoked_at: nil) }
  scope :for_seller, ->(seller_id) { where(seller_id: seller_id) }

  # === Class Methods ===

  # Create a refresh token record from a JWT token
  #
  # @param seller [Seller] The seller this token belongs to
  # @param token [String] The raw JWT token
  # @param payload [Hash] The decoded token payload
  # @return [RefreshToken] The created refresh token record
  def self.create_from_token(seller, token, payload)
    create!(
      seller: seller,
      token_digest: Digest::SHA256.hexdigest(token),
      jti: payload[:jti],
      expires_at: Time.at(payload[:exp])
    )
  end

  # Find a token by its JTI (JWT ID)
  #
  # @param jti [String] The token's unique identifier
  # @return [RefreshToken, nil]
  def self.find_by_jti(jti)
    find_by(jti: jti)
  end

  # Clean up expired tokens (call this periodically via a background job)
  #
  # @return [Integer] Number of records deleted
  def self.cleanup_expired
    expired.delete_all
  end

  # === Instance Methods ===

  # Check if this token is still valid (not revoked and not expired)
  #
  # @return [Boolean]
  def valid_token?
    !revoked? && !expired?
  end

  # Check if this token has been revoked
  #
  # @return [Boolean]
  def revoked?
    revoked_at.present?
  end

  # Check if this token has expired
  #
  # @return [Boolean]
  def expired?
    expires_at <= Time.current
  end

  # Revoke this token
  #
  # @return [Boolean] True if successfully revoked
  def revoke!
    update(revoked_at: Time.current)
  end

  # Verify that a given token matches this record
  #
  # @param token [String] The raw JWT token to verify
  # @return [Boolean]
  def matches_token?(token)
    token_digest == Digest::SHA256.hexdigest(token)
  end
end
