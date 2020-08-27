class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @events = Event.last(3)
  end

  def dashboard
    @event_wishlists = current_user.event_wishlists
  end

  private
end
