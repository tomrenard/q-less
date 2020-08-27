class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def dashboard
    @event_wishlists = current_user.event_wishlists
  end

  private
end
