class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def index
    @events = Event.all
  end

  def show
    set_event
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  def destroy
    set_event
      if @event.destroy
        flash[:notice] = "\"#{@event.title}\" was successfully deleted."
        redirect_to events_path
      else
        flash.now[:alert] = "There was an error deleting the event."
        render :show
      end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :category, :start_time, :end_time, :address, :price, :line_up, :location, :photo)
  end
end
