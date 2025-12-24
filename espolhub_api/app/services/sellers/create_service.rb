module Sellers
  class CreateService < ApplicationService
    def initialize(params:)
      super()
      @params = params
    end

    def call
      seller = Seller.new(seller_params)
      
      if seller.save
        Result.success(seller)
      else
        add_errors(seller.errors.full_messages)
        Result.failure(errors)
      end
    end

    private

    def seller_params
      @params.slice(:name, :email, :phone, :faculty, :password, :password_confirmation)
    end
  end
end