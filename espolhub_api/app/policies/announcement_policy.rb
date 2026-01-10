# frozen_string_literal: true

# Policy for Announcement authorization
# Defines who can view, create, update, and delete announcements
class AnnouncementPolicy < ApplicationPolicy
  # Scope for filtering announcements based on user permissions
  class Scope < Scope
    def resolve
      # All users (including unauthenticated) can see active announcements
      scope.active_listings
    end

    # Scope for viewing a seller's own announcements (including non-active)
    def resolve_for_owner
      return scope.none unless user

      scope.where(seller_id: user.id)
    end
  end

  # Anyone can view the index of announcements
  #
  # @return [Boolean]
  def index?
    true
  end

  # Anyone can view a single announcement
  #
  # @return [Boolean]
  def show?
    true
  end

  # Only authenticated users can create announcements
  #
  # @return [Boolean]
  def create?
    user.present?
  end

  # Only the announcement owner can update it
  #
  # @return [Boolean]
  def update?
    owner?
  end

  # Only the announcement owner can delete it
  #
  # @return [Boolean]
  def destroy?
    owner?
  end

  # Anyone can increment views (public action)
  #
  # @return [Boolean]
  def increment_views?
    true
  end

  # Only the announcement owner can mark it as reserved
  #
  # @return [Boolean]
  def reserve?
    owner?
  end

  # Only the announcement owner can mark it as sold
  #
  # @return [Boolean]
  def mark_as_sold?
    owner?
  end

  # Anyone can search announcements (public action)
  #
  # @return [Boolean]
  def search?
    true
  end

  # Anyone can view popular announcements (public action)
  #
  # @return [Boolean]
  def popular?
    true
  end

  # Anyone can view recent announcements (public action)
  #
  # @return [Boolean]
  def recent?
    true
  end

  private

  # Check if the current user owns this announcement
  #
  # @return [Boolean]
  def owner?
    user && record.seller_id == user.id
  end
end
