module Api
  module V1
    class CategoriesController < BaseController
      # GET /api/v1/categories
      def index
        categories = Category.ordered.with_announcements_count
        
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
                               .paginate(page: params[:page], per_page: params[:per_page])

        render_success(
          AnnouncementSerializer.new(announcements).serializable_hash[:data],
          meta: {
            total_count: category.announcements.active_listings.count,
            category: category.name
          }
        )
      end
    end
  end
end