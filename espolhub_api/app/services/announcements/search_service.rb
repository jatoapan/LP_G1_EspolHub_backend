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
      
      paginated = paginate(announcements)
      
      Result.success(
        announcements: paginated,
        meta: pagination_meta(announcements)
      )
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
      per_page = [[@params[:per_page].to_i, 1].max, 50].min
      per_page = DEFAULT_PER_PAGE if per_page.zero?
      
      query.paginate(page: page, per_page: per_page)
    end

    def pagination_meta(query)
      page = [@params[:page].to_i, 1].max
      per_page = [[@params[:per_page].to_i, DEFAULT_PER_PAGE].max, 50].min
      total = query.count
      
      {
        current_page: page,
        per_page: per_page,
        total_count: total,
        total_pages: (total.to_f / per_page).ceil
      }
    end
  end
end
