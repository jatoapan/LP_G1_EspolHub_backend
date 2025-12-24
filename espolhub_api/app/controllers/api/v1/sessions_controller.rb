module Api
  module V1
    class SessionsController < ApplicationController
      # POST /api/v1/login
      def create
        seller = Seller.find_by(email: params[:email]&.downcase)

        if seller&.authenticate(params[:password])
          token = generate_token(seller)
          render_success({
            token: token,
            seller: SellerSerializer.new(seller).serializable_hash[:data]
          })
        else
          render_error("Email o contraseña incorrectos", status: :unauthorized)
        end
      end

      private

      def generate_token(seller)
        # Implementación simple - usar JWT en producción
        Base64.strict_encode64(seller.id.to_s)
      end
    end
  end
end