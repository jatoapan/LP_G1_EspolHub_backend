module Announcements
  class UpdateService < ApplicationService
    def initialize(announcement:, params:, images: nil)
      super()
      @announcement = announcement
      @params = params
      @images = images
    end

    def call
      validate_announcement!
      return Result.failure(errors) unless success?

      if @announcement.update(announcement_params)
        update_images if @images.present?
        Result.success(@announcement)
      else
        add_errors(@announcement.errors.full_messages)
        Result.failure(errors)
      end
    end

    private

    def validate_announcement!
      add_error("Anuncio no encontrado") unless @announcement.present?
    end

    def announcement_params
      @params.slice(:title, :description, :price, :condition, :status, :category_id)
    end

    def update_images
      @announcement.images.purge
      @images.each { |image| @announcement.images.attach(image) }
    end
  end
end
