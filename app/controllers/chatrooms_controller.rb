class ChatroomsController < ApplicationController
  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
  end

  def new
    @event = Event.find(params[:event_id])
    @chatroom = Chatroom.new
  end

  def create
    @event = Event.find(params[:event_id])
    @chatroom = Chatroom.create(chat_params)
    @chatroom.event = @event
    if @chatroom.save
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  private

  def chat_params
    params.require(:chatroom).permit(:name)
  end
end
