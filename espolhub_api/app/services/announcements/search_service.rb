module Announcements
  class SearchService < ApplicationService
    DEFAULT_PER_PAGE = 12

    def initialize(params:)
      super()
      @params = params
    end

    def call
      announcements = base_query
      announcements = apply_filters(announcements)
      announcements = apply_search(announcements)
      announcements = apply_sorting(announcements)

      paginated_result = paginate(announcements)

      Result.success(paginated_result)
    end

    private

    def base_query
      Announcement.includes(:seller, :category, images_attachments: :blob)
                  .active_listings
    end

    def apply_filters(query)
      query = query.by_category(@params[:category_id])
      query = query.by_condition(@params[:condition])
      query = query.price_range(@params[:min_price], @params[:max_price])
      query
    end

    def apply_search(query)
      query.search(@params[:q])
    end

    def apply_sorting(query)
      case @params[:sort]
      when "price_asc"
        query.order(price: :asc)
      when "price_desc"
        query.order(price: :desc)
      when "popular"
        query.popular
      else
        query.recent
      end
    end

    def paginate(query)
      page = [@params[:page].to_i, 1].max
      per_page_param = @params[:per_page].to_i
      per_page = if per_page_param.positive?
                   [per_page_param, 50].min
                 else
                   DEFAULT_PER_PAGE
                 end

      # Use Kaminari pagination
      collection = query.page(page).per(per_page)

      {
        announcements: collection,
        meta: {
          current_page: collection.current_page,
          per_page: per_page,
          total_count: collection.total_count,
          total_pages: collection.total_pages
        }
      }
    end
  end
end
