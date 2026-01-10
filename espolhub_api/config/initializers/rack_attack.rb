# frozen_string_literal: true

# Rack::Attack Configuration
#
# Provides rate limiting and blocking capabilities to protect the API
# from abuse, brute force attacks, and DoS attempts
#
# See: https://github.com/rack/rack-attack

class Rack::Attack
  ### Configure Cache ###
  #
  # Use Rails.cache for storing rate limit counters
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  ### Throttle Rules ###

  # Throttle login attempts by email
  # Prevents brute force password attacks
  # Limit: 5 requests per 20 seconds per email
  throttle('logins/email', limit: 5, period: 20.seconds) do |req|
    if req.path == '/api/v1/login' && req.post?
      # Normalize email to lowercase
      req.params['email'].to_s.downcase.presence
    end
  end

  # Throttle login attempts by IP
  # Additional protection against distributed brute force attacks
  # Limit: 10 requests per minute per IP
  throttle('logins/ip', limit: 10, period: 1.minute) do |req|
    req.ip if req.path == '/api/v1/login' && req.post?
  end

  # Throttle authenticated API requests
  # Protects against API abuse by authenticated users
  # Limit: 100 requests per minute per seller
  throttle('api/seller', limit: 100, period: 1.minute) do |req|
    if req.path.start_with?('/api/')
      # Extract seller ID from JWT token
      token = extract_bearer_token(req)
      if token
        begin
          payload = Auth::TokenService.decode(token)
          payload[:seller_id] if Auth::TokenService.access_token?(payload)
        rescue Auth::TokenService::TokenError
          nil
        end
      end
    end
  end

  # Throttle unauthenticated API requests
  # Protects public endpoints from abuse
  # Limit: 20 requests per minute per IP
  throttle('api/ip', limit: 20, period: 1.minute) do |req|
    if req.path.start_with?('/api/')
      # Only throttle if not authenticated (no seller_id from above rule)
      req.ip unless extract_bearer_token(req)
    end
  end

  ### Custom Throttle Response ###
  #
  # Return JSON error with retry-after header
  self.throttled_responder = lambda do |env|
    match_data = env['rack.attack.match_data']
    now = match_data[:epoch_time]

    headers = {
      'Content-Type' => 'application/json',
      'Retry-After' => (match_data[:period] - (now % match_data[:period])).to_s
    }

    [429, headers, [{
      error: 'Demasiadas solicitudes. Por favor intenta nuevamente en unos segundos.',
      retry_after: (match_data[:period] - (now % match_data[:period])).to_i
    }.to_json]]
  end

  ### Blocklists ###
  #
  # Block specific IPs or patterns
  # blocklist('block malicious IPs') do |req|
  #   # Block known malicious IPs
  #   ['1.2.3.4', '5.6.7.8'].include?(req.ip)
  # end

  ### Safelists ###
  #
  # Bypass throttling for specific IPs (e.g., health checks, monitoring)
  # safelist('allow health check') do |req|
  #   req.path == '/health'
  # end

  ### Track specific requests ###
  #
  # Track requests for monitoring (doesn't block)
  # track('api/requests') do |req|
  #   req.ip if req.path.start_with?('/api/')
  # end

  ### Helper Methods ###

  # Extract Bearer token from Authorization header
  #
  # @param req [Rack::Request] The request object
  # @return [String, nil] The token if present
  def self.extract_bearer_token(req)
    header = req.env['HTTP_AUTHORIZATION']
    return nil unless header&.start_with?('Bearer ')

    header.split(' ').last
  end
end

# Enable Rack::Attack middleware in production
# Optional in development for testing
Rails.application.config.middleware.use Rack::Attack if Rails.env.production?
