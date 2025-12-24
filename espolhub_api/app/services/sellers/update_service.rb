module Sellers
  class UpdateService < ApplicationService
    def initialize(seller:, params:)
      super()
      @seller = seller
      @params = params
    end

    def call
      validate!
      return Result.failure(errors) unless success?

      if @seller.update(seller_params)
        Result.success(@seller)
      else
        add_errors(@seller.errors.full_messages)
        Result.failure(errors)
      end
    end

    private

    def validate!
      add_error("Vendedor no encontrado") unless @seller.present?
    end

    def seller_params
      permitted = @params.slice(:name, :phone, :faculty)
      permitted.merge!(@params.slice(:password, :password_confirmation)) if @params[:password].present?
      permitted
    end
  end
end