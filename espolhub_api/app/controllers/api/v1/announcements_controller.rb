module Api
  module V1
    class AnnouncementsController < BaseController
      before_action :authenticate_seller!, only: [:create, :update, :destroy]
      before_action :set_announcement, only: [:show, :update, :destroy]
      after_action :verify_authorized, except: [:index, :show]

      # GET /api/v1/announcements
      def index
        authorize Announcement
        result = Announcements::SearchService.call(params: search_params)

        if result.success?
          announcements = result.value[:announcements]
          meta = result.value[:meta]
          
          render_success(
            AnnouncementSerializer.new(announcements).serializable_hash[:data],
            meta: meta
          )
        else
          render_error(result.errors)
        end
      end

      # GET /api/v1/announcements/:id
      def show
        authorize @announcement
        @announcement.increment_views!

        render_success(
          AnnouncementSerializer.new(@announcement, include: [:seller, :category]).serializable_hash[:data]
        )
      end

      # POST /api/v1/announcements
      def create
        authorize Announcement
        result = Announcements::CreateService.call(
          seller: current_seller,
          params: announcement_params,
          images: params[:images]
        )

        result.on_success do |announcement|
          render_success(
            AnnouncementSerializer.new(announcement).serializable_hash[:data],
            status: :created
          )
        end.on_failure do |errors|
          render_error(errors)
        end
      end

      # PATCH/PUT /api/v1/announcements/:id
      def update
        authorize @announcement

        result = Announcements::UpdateService.call(
          announcement: @announcement,
          params: announcement_params,
          images: params[:images]
        )

        result.on_success do |announcement|
          render_success(AnnouncementSerializer.new(announcement).serializable_hash[:data])
        end.on_failure do |errors|
          render_error(errors)
        end
      end

      # DELETE /api/v1/announcements/:id
      def destroy
        authorize @announcement

        result = Announcements::DeleteService.call(
          announcement: @announcement,
          seller: current_seller
        )

        result.on_success do
          head :no_content
        end.on_failure do |errors|
          render_error(errors, status: :forbidden)
        end
      end

      private

      def set_announcement
        @announcement = Announcement.includes(:seller, :category, images_attachments: :blob)
                                    .find(params[:id])
      end

      def announcement_params
        params.require(:announcement).permit(
          :title,
          :description,
          :price,
          :condition,
          :status,
          :category_id
        )
      end

      def search_params
        params.permit(
          :q,
          :category_id,
          :condition,
          :min_price,
          :max_price,
          :sort,
          :page,
          :per_page
        )
      end
    end
  end
end
