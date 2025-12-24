class SellerSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :faculty

  # Atributos públicos (visibles para otros usuarios)
  attribute :whatsapp_link do |object, params|
    object.whatsapp_link unless params[:public] == false
  end

  # Atributos privados (solo para el propio usuario)
  attribute :email do |object, params|
    object.email unless params[:public]
  end

  attribute :phone do |object, params|
    object.phone unless params[:public]
  end

  attribute :created_at do |object, params|
    object.created_at unless params[:public]
  end

  # attribute :announcements_count do |object|
  #   object.announcements.active_listings.count
  # end
end