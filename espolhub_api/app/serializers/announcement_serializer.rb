class AnnouncementSerializer
  include JSONAPI::Serializer

  attributes :title, :description, :price, :condition, :status, :views_count, :created_at, :updated_at

  attribute :condition_label do |object|
    object.condition_label
  end

  attribute :status_label do |object|
    object.status_label
  end

  attribute :main_image_url do |object|
    object.main_image_url
  end

  attribute :image_urls do |object|
    object.image_urls
  end

  attribute :formatted_price do |object|
    "$#{format('%.2f', object.price)}"
  end

  belongs_to :seller, serializer: SellerSerializer
  belongs_to :category, serializer: CategorySerializer
end
