class EventsController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_filter :admin_user,     only: [:new, :create, :edit, :update, :destroy]

  def index
    @events = Event.page(params[:page]).order('name ASC')
  end

  def show
    @event = Event.find(params[:id])
    if signed_in? && @event
      invitations = @event.invitations.where(invited_user_id: current_user.id)
      # Highlander (there can be only one).
      if !invitations.empty?
        @invitation = invitations[0]
      end
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])
    if @event.save
      flash[:success] = "Created event #{@event.name}."
      redirect_to @event
    else
      render 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:success] = "Event updated."
      redirect_to @event
    else
      render 'edit'
    end
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    redirect_to events_path, success: "Event deleted."
  end
end

