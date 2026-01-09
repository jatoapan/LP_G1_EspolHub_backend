class CategorySerializer
  include JSONAPI::Serializer

  attributes :id, :name, :description, :icon, :active

  attribute :announcements_count do |category|
    # Use counter if available from scope, otherwise query
    if category.respond_to?(:active_announcements_count) && category.active_announcements_count.present?
      category.active_announcements_count
    else
      category.active_announcements_count
    end
  end
end
