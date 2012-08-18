class TalksController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_filter :admin_user,     only: [:new, :create, :edit, :update, :destroy]

  def show
    @talk = Talk.find(params[:id])
  end

  def new
    event = Event.find_by_id(params[:event_id])
    if event.nil?
      flash[:error] = "Could not find event #{params[:event_id]}."
      redirect_to root_path
    else
      @talk = event.talks.build
      @talk.start_at = event.start_date.to_datetime.change({hour: 9, minute: 0})
      @talk.end_at = event.start_date.to_datetime.change({hour: 10, minute: 0})
    end
  end

  def create
    event = Event.find_by_id(params[:event_id])
    if event.nil?
      flash[:error] = "Could not find event #{params[:event_id]}."
      redirect_to root_path
    else
      @talk = event.talks.build(params[:talk])
      if @talk.save
        flash[:success] = "Created talk #{@talk.title}."
        redirect_to @talk.event
      else
        render 'new'
      end
    end
  end

  def edit
    @talk = Talk.find(params[:id])
  end

  def update
    @talk = Talk.find(params[:id])
    if @talk.update_attributes(params[:talk])
      flash[:success] = "Talk updated."
      redirect_to @talk
    else
      render 'edit'
    end
  end

  def destroy
    talk = Talk.find(params[:id])
    event = talk.event
    talk.destroy
    redirect_to event, success: "Removed talk #{talk.title}."
  end
end
