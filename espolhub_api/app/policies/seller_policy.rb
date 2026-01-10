# frozen_string_literal: true

# Policy for Seller authorization
# Defines who can view, update, and delete seller profiles
class SellerPolicy < ApplicationPolicy
  # Scope for filtering sellers based on user permissions
  class Scope < Scope
    def resolve
      # All users can see all seller profiles (public)
      scope.all
    end
  end

  # Anyone can create a seller account (registration is public)
  #
  # @return [Boolean]
  def create?
    true
  end

  # Anyone can view seller profiles
  #
  # @return [Boolean]
  def show?
    true
  end

  # Anyone can view the /me endpoint to see their own profile
  #
  # @return [Boolean]
  def me?
    user.present?
  end

  # Only the seller themselves can update their own profile
  #
  # @return [Boolean]
  def update?
    owner?
  end

  # Only the seller themselves can delete their own account
  #
  # @return [Boolean]
  def destroy?
    owner?
  end

  # Only the seller can view their own announcements
  #
  # @return [Boolean]
  def announcements?
    true # Public endpoint - anyone can see a seller's announcements
  end

  private

  # Check if the current user is the seller being acted upon
  #
  # @return [Boolean]
  def owner?
    user && record.id == user.id
  end
end
