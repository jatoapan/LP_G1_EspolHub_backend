module Announcements
  class CreateService < ApplicationService
    def initialize(seller:, params:, images: [])
      super()
      @seller = seller
      @params = params
      @images = images
    end

    def call
      validate_seller!
      return Result.failure(errors) unless success?

      announcement = build_announcement
      
      if announcement.save
        attach_images(announcement)
        Result.success(announcement)
      else
        add_errors(announcement.errors.full_messages)
        Result.failure(errors)
      end
    end

    private

    def validate_seller!
      add_error("Vendedor no encontrado") unless @seller.present?
    end

    def build_announcement
      @seller.announcements.build(announcement_params)
    end

    def announcement_params
      @params.slice(:title, :description, :price, :condition, :category_id)
    end

    def attach_images(announcement)
      return if @images.blank?
      
      @images.each do |image|
        announcement.images.attach(image)
      end
    end
  end
end
