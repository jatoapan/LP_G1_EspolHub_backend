module Api
  module V1
    class SellersController < BaseController
      before_action :authenticate_seller!, only: [:update, :destroy, :me]
      before_action :set_seller, only: [:show]

      # POST /api/v1/sellers (Registro)
      def create
        result = Sellers::CreateService.call(params: seller_params)

        result.on_success do |seller|
          render_success(
            SellerSerializer.new(seller).serializable_hash[:data],
            status: :created
          )
        end.on_failure do |errors|
          render_error(errors)
        end
      end

      # GET /api/v1/sellers/:id
      def show
        render_success(
          SellerSerializer.new(@seller, params: { public: true }).serializable_hash[:data]
        )
      end

      # GET /api/v1/sellers/me (Perfil propio)
      def me
        render_success(
          SellerSerializer.new(current_seller).serializable_hash[:data]
        )
      end

      # PATCH/PUT /api/v1/sellers/me
      def update
        result = Sellers::UpdateService.call(
          seller: current_seller,
          params: seller_params
        )

        result.on_success do |seller|
          render_success(SellerSerializer.new(seller).serializable_hash[:data])
        end.on_failure do |errors|
          render_error(errors)
        end
      end

      # DELETE /api/v1/sellers/me
      def destroy
        if current_seller.destroy
          head :no_content
        else
          render_error(current_seller.errors.full_messages)
        end
      end

      # GET /api/v1/sellers/:id/announcements
      def announcements
        seller = Seller.find(params[:id])
        announcements = seller.announcements
                             .active_listings
                             .includes(:category, images_attachments: :blob)
                             .recent

        render_success(AnnouncementSerializer.new(announcements).serializable_hash[:data])
      end

      private

      def set_seller
        @seller = Seller.find(params[:id])
      end

      def seller_params
        params.require(:seller).permit(
          :name,
          :email,
          :phone,
          :faculty,
          :password,
          :password_confirmation
        )
      end
    end
  end
end
