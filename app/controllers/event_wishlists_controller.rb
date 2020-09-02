class EventWishlistsController < ApplicationController
  def update
    @event_wishlist = EventWishlist.where(event:Event.find(params[:event]), user: current_user)
    if @event_wishlist == []
      EventWishlist.create(event:Event.find(params[:event]), user: current_user)
      @event_wishlist_exit = true
    else
      @event_wishlist.destroy_all
      @event_wishlist_exit = false
    end
    respond_to do |format|
    format.html{}
    format.js{}
    end
    authorize @event_wishlist
    # redirect_to event_path(@event)
  end
end
