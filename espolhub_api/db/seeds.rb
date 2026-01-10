# This file creates seed data for testing

# Create categories
categories_data = ['Electronics', 'Books', 'Clothing', 'Furniture', 'Services']
categories = categories_data.map do |name|
  Category.find_or_create_by!(name: name) do |cat|
    cat.description = "#{name} category"
    cat.active = true
  end
end
puts "Created #{Category.count} categories"

# Create a test seller
seller = Seller.find_or_create_by!(email: 'test@espol.edu.ec') do |s|
  s.name = 'Test User'
  s.phone = '0991234567'
  s.faculty = 'FIEC'
  s.password = 'Password123'
  s.password_confirmation = 'Password123'
end
puts "Created seller: #{seller.email}"

# Create some announcements if none exist
if Announcement.count == 0
  3.times do |i|
    Announcement.create!(
      title: "Test Announcement #{i+1} - Great Product",
      description: "This is a test description for announcement #{i+1}. It has great value and quality.",
      price: (i+1) * 100,
      condition: [:new_item, :like_new, :good][i],
      status: :active,
      seller: seller,
      category: categories[i % categories.length],
      location: 'ESPOL Campus'
    )
  end
  puts "Created #{Announcement.count} announcements"
else
  puts "Announcements already exist: #{Announcement.count}"
end
