class EventsController < ApplicationController
  # before_action :authenticate_user!, only: [:new, :create]

  def index
    @events = Event.order('event_date_time')
    @events = policy_scope(Event).geocoded

    if params[:query_word].present?
      sql_query = "title ILIKE :query OR description ILIKE :query OR location ILIKE :query OR line_up ILIKE :query"
      @events = @events.where(sql_query, query: "%#{params[:query_word]}%")
    end

    if params[:event_date].present?
      @events = @events.select { |event| event.start_time == params[:event_date] }
    end
    @markers = @events.map do |event|
      {
        lat: event.latitude,
        lng: event.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { event: event })
      }
    end
  end

  def show
    @favorite_exists = EventWishlist.where(event: @event, user: current_user) == [] ? false : true
    set_event
    @related_events = @event.find_related_tags
    @chatroom = @event.chatroom
    @message = Message.new
    @last_queues = @event.queue_estimations.last(3)
    @very_last_queues = @event.queue_estimations.last(1)
  end

  def edit
    set_event
  end

  def new
    @event = Event.new
    authorize @event
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if @event.save
      @event.create_chatroom!(name: "Clubchat")
      redirect_to event_path(@event)
    else
      render :new
    end
    authorize @event
  end

  def update
    set_event
    if @event.update(event_params)
      redirect_to @event, notice: "#{@event.title} was succesfully updated"
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

  def tagged
    if params[:tag].present?
      @events = Event.tagged_with(params[:tag])
    else
      @events = Event.all
    end
  end

  # def self.search(search)
  #   if search
  #     events = Event.all
  #     events = events.where(start_time: search[:":start_time"][","])
  #     return events
  #   else
  #     Event.all
  #   end
  # end

  private

  def set_event
    @event = Event.find(params[:id])
    authorize @event
  end

  def event_params
    params.require(:event).permit(:title, :description, :category, :start_time, :end_time, :address, :price, :line_up, :location, :photo, :tag_list)
  end
end
