class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @events = Event.last(4)
  end

  def dashboard
    # @event = Event.find(params[:id])
    @event_wishlists = current_user.event_wishlists
    @followings = current_user.followings
  end
end
