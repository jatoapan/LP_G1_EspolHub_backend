module Api
  module V1
    class CategoriesController < BaseController
      # GET /api/v1/categories
      def index
        categories = Category.alphabetical.with_announcements_count

        render_success(CategorySerializer.new(categories).serializable_hash[:data])
      end

      # GET /api/v1/categories/:id
      def show
        category = Category.find(params[:id])

        render_success(CategorySerializer.new(category).serializable_hash[:data])
      end

      # GET /api/v1/categories/:id/announcements
      def announcements
        category = Category.find(params[:id])
        announcements = category.announcements
          .active_listings
          .includes(:seller, images_attachments: :blob)
          .recent
          .page(params[:page]).per(params[:per_page] || 12)

        render_success(
          AnnouncementSerializer.new(announcements).serializable_hash[:data],
          meta: {
            current_page: announcements.current_page,
            per_page: announcements.limit_value,
            total_count: announcements.total_count,
            total_pages: announcements.total_pages,
            category: category.name
          }
        )
      end
    end
  end
end

