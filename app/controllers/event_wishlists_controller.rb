class EventWishlistsController < ApplicationController
  def create
    @EventWishlists = QueueEstimation.create(queue_params)
    @queue_estimation.user = current_user
    @queue_estimation.event = @event
    # authorize @queue_estimation
    if @queue_estimation.save
      redirect_to queue_estimation_path(@queue_estimation)
    else
      render :new
    end
  end
end
