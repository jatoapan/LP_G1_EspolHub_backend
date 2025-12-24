class CategorySerializer
  include JSONAPI::Serializer

  attributes :id, :name, :slug, :description, :icon, :position

  attribute :announcements_count do |object|
    if object.respond_to?(:announcements_count)
      object.announcements_count
    else
      object.announcements.active_listings.count
    end
  end
end