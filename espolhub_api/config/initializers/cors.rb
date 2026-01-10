# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#   allow do
#     origins "example.com"
#
#     resource "*",
#       headers: :any,
#       methods: [:get, :post, :put, :patch, :delete, :options, :head]
#   end
# end


# CORS Configuration - Environment-based Origins
#
# Configure allowed origins based on environment
# Development: Uses localhost by default
# Production: Uses ALLOWED_ORIGINS environment variable
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Dynamic origin checking based on environment
    origins do |source, env|
      # Get allowed origins from environment variable or use defaults
      allowed_origins = ENV.fetch('ALLOWED_ORIGINS', 'http://localhost:3001,http://localhost:3000').split(',').map(&:strip)

      # In development, allow all localhost origins
      # In production, strictly check against configured origins
      if Rails.env.development?
        source =~ /\Ahttp:\/\/localhost:\d+\z/ || allowed_origins.include?(source)
      else
        allowed_origins.include?(source)
      end
    end

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true,
      max_age: 600 # Cache preflight requests for 10 minutes
  end
end