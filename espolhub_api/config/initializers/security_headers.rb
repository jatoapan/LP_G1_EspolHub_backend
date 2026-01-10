# frozen_string_literal: true

# Security Headers Configuration
#
# Sets HTTP security headers to protect against common web vulnerabilities
# See: https://owasp.org/www-project-secure-headers/

Rails.application.config.action_dispatch.default_headers = {
  # Prevent clickjacking attacks by disallowing the page to be framed
  'X-Frame-Options' => 'DENY',

  # Prevent MIME type sniffing
  'X-Content-Type-Options' => 'nosniff',

  # Enable XSS protection (legacy, modern browsers use CSP)
  'X-XSS-Protection' => '1; mode=block',

  # Control information sent in Referer header
  'Referrer-Policy' => 'strict-origin-when-cross-origin',

  # Prevent browsers from MIME-sniffing a response away from the declared content-type
  'X-Download-Options' => 'noopen',

  # Prevents browsers from sending the Referer header when navigating from HTTPS to HTTP
  'X-Permitted-Cross-Domain-Policies' => 'none'
}

# Content Security Policy (CSP) - Disabled for API-only application
# Uncomment and configure if serving HTML content
# Rails.application.config.content_security_policy do |policy|
#   policy.default_src :none
#   policy.connect_src :self
# end

# Strict-Transport-Security (HSTS) - Enable in production
# Forces browsers to use HTTPS for all requests
if Rails.env.production?
  Rails.application.config.force_ssl = true
  Rails.application.config.ssl_options = {
    hsts: {
      expires: 1.year,
      subdomains: true,
      preload: true
    }
  }
end
