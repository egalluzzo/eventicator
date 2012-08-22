class InvitationsController < ApplicationController
  before_filter :signed_in_user

  def new
    event = Event.find_by_id(params[:event_id])
    if (event.nil?)
      redirect_to root_path, error: "Could not find event #{params[:event_id]}."
    else
      @invitation = event.invitations.build(params[:invitation])
    end
  end

  def create
    event = Event.find_by_id(params[:event_id])
    if (event.nil?)
      redirect_to root_path, error: "Could not find event #{params[:event_id]}."
    else
      # @invitation.invited_email can be a list of email addresses, so we need
      # to separate these by commas and optional spaces.
      # Alternatively, we could be creating an invitation for ourselves or
      # another user.
      invited_email = params[:invitation][:invited_email]
      if invited_email.nil?
        invitation = event.invitations.build(params[:invitation])
        unless invitation.save
          flash[:error] = "Could not register for this event."
        end
      else
        emails = invited_email.split(%r{,\s*})
        rejected_emails = []
        emails.each do |email|
          invitation = event.invitations.build(inviting_user_id: current_user.id,
                                               invited_email:    email)
          if invitation.save
            invitation.send_email
          else
            rejected_emails << email
          end
          if !rejected_emails.empty?
            flash[:error] = "Could not send emails to #{rejected_emails.join(', ')}"
          end
        end
      end
      redirect_to event_path(event)
    end
  end

  def edit
    @invitation = Invitation.find_by_token(params[:id])
    if @invitation.nil?
      redirect_to root_path, error: "Could not find your invitation, sorry!"
    else
      if @invitation.invited_user.nil?
        @invitation.invited_user = current_user
        @invitation.invited_email = nil
      end
      if !@invitation.save
        flash[:error] = "Could not prepare your invitation."
      end
      redirect_to event_path(@invitation.event)
    end
  end

  def update
    @invitation = Invitation.find_by_token(params[:id])
    if @invitation.update_attributes(params[:invitation])
      redirect_to @invitation.event
    else
      render 'edit'
    end
  end
end
