# frozen_string_literal: true

# db/seeds.rb
# Main seed orchestrator for ESPOL Hub API
#
# This file coordinates the seeding process based on the Rails environment.
# It loads environment-specific seed files in the correct order.
#
# Usage:
#   rails db:seed                    # Seed based on current environment
#   RAILS_ENV=production rails db:seed  # Seed production (categories only)
#   rails db:reset                   # Drop, create, migrate, and seed
#
# Structure:
#   db/seeds/
#   ├── shared/
#   │   └── categories_data.rb      # Shared category definitions
#   ├── development/
#   │   ├── 01_sellers.rb           # Test users
#   │   ├── 02_categories.rb        # Categories with examples
#   │   └── 03_announcements.rb     # Rich sample data
#   └── production/
#       └── categories.rb           # Production-safe categories only

puts ''
puts '=' * 60
puts '🌱 ESPOL Hub Database Seeding'
puts '=' * 60
puts "Environment: #{Rails.env.upcase}"
puts "Time: #{Time.current.strftime('%Y-%m-%d %H:%M:%S')}"
puts '=' * 60

# Safety confirmation for production
if Rails.env.production?
  puts ''
  puts '⚠️  WARNING: You are about to seed the PRODUCTION database!'
  puts '   This will add/update categories but NOT delete existing data.'
  puts ''

  # Only prompt if running interactively
  if $stdin.tty?
    print 'Type "yes" to continue: '
    response = $stdin.gets&.chomp
    unless response&.downcase == 'yes'
      puts '❌ Seeding cancelled.'
      exit 1
    end
  else
    puts '   Running in non-interactive mode, proceeding...'
  end
end

# Load shared data module
puts "\n📚 Loading shared data modules..."
require_relative 'seeds/shared/categories_data'
puts '   ✅ SeedData module loaded'

# Track timing
start_time = Time.current

begin
  case Rails.env
  when 'development', 'test'
    puts "\n📦 Loading DEVELOPMENT seeds..."
    puts '   This includes test users, categories, and sample announcements.'
    puts ''

    # Load seed files in order (sorted by filename)
    seed_files = Dir[Rails.root.join('db/seeds/development/*.rb')].sort

    seed_files.each do |file|
      filename = File.basename(file)
      puts "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      puts "📄 Loading: #{filename}"
      puts '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
      load file
    end

  when 'production'
    puts "\n🏭 Loading PRODUCTION seeds..."
    puts '   Only categories will be seeded (safe operation).'
    puts ''

    seed_file = Rails.root.join('db/seeds/production/categories.rb')
    if File.exist?(seed_file)
      load seed_file
    else
      puts '❌ Production seed file not found!'
      exit 1
    end

  else
    puts "❌ Unknown environment: #{Rails.env}"
    puts '   Supported environments: development, test, production'
    exit 1
  end

rescue StandardError => e
  puts ''
  puts '=' * 60
  puts '❌ SEEDING FAILED'
  puts '=' * 60
  puts "Error: #{e.message}"
  puts "Location: #{e.backtrace.first}"
  puts ''
  raise e
end

# Calculate elapsed time
elapsed_time = Time.current - start_time

# Final summary
puts ''
puts '=' * 60
puts '✅ SEEDING COMPLETED SUCCESSFULLY'
puts '=' * 60
puts ''
puts '📊 Final Database State:'
puts "   • Categories:     #{Category.count}"
puts "   • Sellers:        #{Seller.count}"
puts "   • Announcements:  #{Announcement.count}"
puts "   • Refresh Tokens: #{RefreshToken.count}"
puts ''
puts "⏱️  Total time: #{elapsed_time.round(2)} seconds"
puts ''

if Rails.env.development?
  puts '🔐 Test Credentials:'
  puts '   Email:    admin@espol.edu.ec'
  puts '   Password: Password123'
  puts ''
end

puts '=' * 60
puts ''
