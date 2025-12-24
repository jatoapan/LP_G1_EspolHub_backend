module Announcements
  class DeleteService < ApplicationService
    def initialize(announcement:, seller:)
      super()
      @announcement = announcement
      @seller = seller
    end

    def call
      validate!
      return Result.failure(errors) unless success?

      if @announcement.destroy
        Result.success(message: "Anuncio eliminado exitosamente")
      else
        add_errors(@announcement.errors.full_messages)
        Result.failure(errors)
      end
    end

    private

    def validate!
      add_error("Anuncio no encontrado") unless @announcement.present?
      add_error("No autorizado para eliminar este anuncio") unless owner?
    end

    def owner?
      @announcement&.seller_id == @seller&.id
    end
  end
end
