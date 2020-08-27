class QueueEstimationsController < ApplicationController
  before_action :set_queue_estimation, only: [:show, :destroy]
  before_action :set_event, only: [:new, :create]

  def index
    @queue_estimations = QueueEstimation.last(3)
    # policy_scope().where(user_id: current_user.id) for pundit
  end

  def show
    @queue_estimation = QueueEstimation.find(params[:id])
    # @queue_estimation = QueueEstimation.last
    # is this how we want it??
    authorize @queue_estimation
  end

  def new
    @queue_estimation = QueueEstimation.new
    # authorize @queue_estimation
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
    set_event
    if @queue_estimation.destroy
      flash[:notice] = "Your estimation was successfully deleted."
      redirect_to event_path(@event)
    else
      flash.now[:alert] = "There was an error deleting your estimation."
      render :show
    end
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
