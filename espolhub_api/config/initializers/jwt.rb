# frozen_string_literal: true

# JWT Configuration for Authentication
# Uses HS256 algorithm with Rails secret key base or custom JWT secret

module JwtConfig
  # Secret key for signing JWT tokens
  # In production, use a dedicated JWT_SECRET_KEY environment variable
  # Fallback to Rails secret_key_base for development
  JWT_SECRET = ENV.fetch('JWT_SECRET_KEY') { Rails.application.credentials.secret_key_base }

  # Algorithm for JWT encoding/decoding
  JWT_ALGORITHM = 'HS256'

  # Token expiration times
  JWT_ACCESS_TOKEN_EXPIRATION = 24.hours
  JWT_REFRESH_TOKEN_EXPIRATION = 7.days

  # Token types
  ACCESS_TOKEN = 'access'
  REFRESH_TOKEN = 'refresh'
end
