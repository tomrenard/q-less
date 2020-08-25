class QueueEstimationsController < ApplicationController
  before_action :set_queue_estimation, only: [:show, :destroy]
  before_action :set_event, only: [:new, :create]

  def index
    @queue_estimations = QueueEstimation.all
    # is syntax right?
    # do we need policy scope and to identify current user?
    # policy_scope().where(user_id: current_user.id)
  end

  def show
    @queue_estimation = QueueEstimation.find(params[:id])
    # authorize @queue_estimation
  end

  def new
    @queue_estimation = QueueEstimation.new
    authorize @queue_estimation
  end

  def create
    @queue_estimation = QueueEstimation.create(queue_params)
    @queue_estimation.user = current_user
    @queue_estimation.event = @event
    authorize @queue_estimation
    if @queue_estimation.save
      redirect_to queue_estimation_path(@queue_estimation)
    else
      render :new
    end
  end

  def destroy
    @queue_estimation.destroy
    redirect_to root_path
  end

  private

  def set_queue_estimation
    @queue_estimation = QueueEstimation.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def queue_params
    params.require(:queue_estimation).permit(:waiting_time)
  end
end
