# frozen_string_literal: true

# db/seeds/development/01_sellers.rb
# Development test users for ESPOL Hub
# Creates diverse sellers from different faculties

puts "\n  👥 Seeding Sellers (Development Mode)..."

# Data for test sellers - diverse faculties and profiles
SELLERS_DATA = [
  {
    email: 'admin@espol.edu.ec',
    password: 'Password123',
    password_confirmation: 'Password123',
    name: 'Admin Sistema',
    phone: '0990000001',
    faculty: 'FIEC'
  },
  {
    email: 'juan.perez@espol.edu.ec',
    password: 'Password123',
    password_confirmation: 'Password123',
    name: 'Juan Pérez García',
    phone: '0991234567',
    faculty: 'FIEC'
  },
  {
    email: 'maria.garcia@espol.edu.ec',
    password: 'Password123',
    password_confirmation: 'Password123',
    name: 'María García López',
    phone: '0992345678',
    faculty: 'FCNM'
  },
  {
    email: 'carlos.rodriguez@espol.edu.ec',
    password: 'Password123',
    password_confirmation: 'Password123',
    name: 'Carlos Rodríguez Mora',
    phone: '0993456789',
    faculty: 'FIMCP'
  },
  {
    email: 'ana.martinez@espol.edu.ec',
    password: 'Password123',
    password_confirmation: 'Password123',
    name: 'Ana Martínez Vera',
    phone: '0994567890',
    faculty: 'FADCOM'
  },
  {
    email: 'luis.sanchez@espol.edu.ec',
    password: 'Password123',
    password_confirmation: 'Password123',
    name: 'Luis Sánchez Torres',
    phone: '0995678901',
    faculty: 'FIEC'
  },
  {
    email: 'sofia.mendoza@espol.edu.ec',
    password: 'Password123',
    password_confirmation: 'Password123',
    name: 'Sofía Mendoza Ruiz',
    phone: '0996789012',
    faculty: 'FCSH'
  },
  {
    email: 'diego.herrera@espol.edu.ec',
    password: 'Password123',
    password_confirmation: 'Password123',
    name: 'Diego Herrera Paz',
    phone: '0997890123',
    faculty: 'ESPAE'
  }
].freeze

created_count = 0
skipped_count = 0
error_count = 0

SELLERS_DATA.each do |seller_data|
  # Check if seller already exists
  existing = Seller.find_by(email: seller_data[:email])

  if existing
    skipped_count += 1
    puts "    ⏭️  Exists: #{seller_data[:name]} (#{seller_data[:email]})"
    next
  end

  begin
    seller = Seller.create!(seller_data)
    created_count += 1
    puts "    ✅ Created: #{seller.name} (#{seller.email}) - #{seller.faculty}"
  rescue ActiveRecord::RecordInvalid => e
    error_count += 1
    puts "    ❌ Error: #{seller_data[:name]} - #{e.message}"
  end
end

puts "\n  📊 Seller Summary:"
puts "    • Total in database: #{Seller.count}"
puts "    • Created this run: #{created_count}"
puts "    • Skipped (existing): #{skipped_count}"
puts "    • Errors: #{error_count}"

# Show faculty distribution
puts "\n  🏛️  Sellers by Faculty:"
Seller.group(:faculty).count.sort_by { |_, v| -v }.each do |faculty, count|
  puts "    • #{faculty}: #{count}"
end
