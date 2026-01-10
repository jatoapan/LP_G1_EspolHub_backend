# frozen_string_literal: true

# db/seeds/development/02_categories.rb
# Development category seeding - uses shared data
# Identical to production but with extra logging

puts "\n  📂 Seeding Categories (Development Mode)..."

# Reuse production seed logic
load Rails.root.join('db/seeds/production/categories.rb')
