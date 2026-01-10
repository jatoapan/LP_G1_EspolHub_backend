# frozen_string_literal: true

module Auth
  # Service for JWT token generation, verification, and management
  # Handles both access tokens (short-lived) and refresh tokens (long-lived)
  class TokenService
    # Custom error classes for better error handling
    class TokenError < StandardError; end
    class ExpiredTokenError < TokenError; end
    class InvalidTokenError < TokenError; end

    class << self
      # Encode a payload into a JWT token
      #
      # @param payload [Hash] The data to encode in the token
      # @param expiration [ActiveSupport::Duration] How long until the token expires
      # @return [String] The encoded JWT token
      def encode(payload, expiration = JwtConfig::JWT_ACCESS_TOKEN_EXPIRATION)
        payload[:exp] = expiration.from_now.to_i
        payload[:iat] = Time.current.to_i

        JWT.encode(payload, JwtConfig::JWT_SECRET, JwtConfig::JWT_ALGORITHM)
      end

      # Decode a JWT token and return the payload
      #
      # @param token [String] The JWT token to decode
      # @return [Hash] The decoded payload
      # @raise [ExpiredTokenError] If the token has expired
      # @raise [InvalidTokenError] If the token is invalid
      def decode(token)
        body = JWT.decode(token, JwtConfig::JWT_SECRET, true, algorithm: JwtConfig::JWT_ALGORITHM)[0]
        HashWithIndifferentAccess.new(body)
      rescue JWT::ExpiredSignature
        raise ExpiredTokenError, 'Token has expired'
      rescue JWT::DecodeError => e
        raise InvalidTokenError, "Invalid token: #{e.message}"
      end

      # Generate an access token for a seller
      #
      # @param seller [Seller] The seller to generate a token for
      # @return [String] The access token
      def generate_access_token(seller)
        payload = {
          seller_id: seller.id,
          email: seller.email,
          type: JwtConfig::ACCESS_TOKEN
        }

        encode(payload, JwtConfig::JWT_ACCESS_TOKEN_EXPIRATION)
      end

      # Generate a refresh token for a seller
      #
      # @param seller [Seller] The seller to generate a token for
      # @return [String] The refresh token
      def generate_refresh_token(seller)
        payload = {
          seller_id: seller.id,
          type: JwtConfig::REFRESH_TOKEN,
          jti: SecureRandom.uuid # Unique token identifier for revocation
        }

        encode(payload, JwtConfig::JWT_REFRESH_TOKEN_EXPIRATION)
      end

      # Verify a token and return the decoded payload if valid
      #
      # @param token [String] The token to verify
      # @return [Hash, nil] The decoded payload if valid, nil otherwise
      def verify_token(token)
        decode(token)
      rescue TokenError
        nil
      end

      # Check if a token is an access token
      #
      # @param payload [Hash] The decoded token payload
      # @return [Boolean]
      def access_token?(payload)
        payload[:type] == JwtConfig::ACCESS_TOKEN
      end

      # Check if a token is a refresh token
      #
      # @param payload [Hash] The decoded token payload
      # @return [Boolean]
      def refresh_token?(payload)
        payload[:type] == JwtConfig::REFRESH_TOKEN
      end

      # Extract the seller ID from a token payload
      #
      # @param payload [Hash] The decoded token payload
      # @return [Integer, nil] The seller ID if present
      def seller_id_from_payload(payload)
        payload[:seller_id]
      end
    end
  end
end
