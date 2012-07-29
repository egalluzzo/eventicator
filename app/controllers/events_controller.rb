class EventsController < ApplicationController

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])
    if @event.save
      flash[:success] = "Created event #{event.name}"
      redirect_to @event
    else
      render 'new'
    end
  end
end
