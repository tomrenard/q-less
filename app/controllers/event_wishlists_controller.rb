class EventWishlistsController < ApplicationController
  def create
    @event = Event.find(event_wishlist_params[:event_id])
    @event_wishlist = EventWishlist.create!({ user:current_user, event:@event })
    if @event_wishlist.save
      events_path(@event)
    else
      events_path(@event)
      raise
    end
      authorize @event_wishlist
  end

  def destroy

  end

  private

  def event_wishlist_params
    params.permit(:event_id)
  end
end

