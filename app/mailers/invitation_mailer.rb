class InvitationMailer < ActionMailer::Base
  default from: "invitations@eventicator.com"

  def invitation_email(invitation)
  	@invitation = invitation
  	@url = edit_invitation_url(invitation.token)
  	mail(to:      invitation.invited_email || invitation.invited_user.email,
  	     subject: "You're invited to #{invitation.event.name}!")
  end
end
