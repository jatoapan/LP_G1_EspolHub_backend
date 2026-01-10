# frozen_string_literal: true

# db/seeds/production/categories.rb
# Production-safe category seeding
# Idempotent - safe to run multiple times

puts "\n  📂 Seeding Categories (Production Mode)..."

created_count = 0
updated_count = 0
error_count = 0

SeedData::CATEGORIES.each do |category_data|
  # Use case-insensitive lookup for idempotency
  # The Category model normalizes names (capitalizes), so we search normalized
  normalized_name = category_data[:name].strip.capitalize
  category = Category.find_or_initialize_by(name: normalized_name)

  was_new_record = category.new_record?

  category.assign_attributes(
    description: category_data[:description],
    icon: category_data[:icon],
    active: true
  )

  if category.save
    if was_new_record
      created_count += 1
      puts "    ✨ Created: #{category.name}"
    elsif category.saved_changes.any?
      updated_count += 1
      puts "    🔄 Updated: #{category.name}"
    else
      puts "    ⏭️  Unchanged: #{category.name}"
    end
  else
    error_count += 1
    puts "    ❌ Error: #{category_data[:name]} - #{category.errors.full_messages.join(', ')}"
  end
end

puts "\n  📊 Category Summary:"
puts "    • Total in database: #{Category.count}"
puts "    • Created this run: #{created_count}"
puts "    • Updated this run: #{updated_count}"
puts "    • Errors: #{error_count}"
puts "    • Active categories: #{Category.where(active: true).count}"
