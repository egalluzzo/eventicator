class Invitation < ActiveRecord::Base
  attr_accessible :accepted, :attended, :invited_email, :invited_user_id,
                  :inviting_user_id

  belongs_to :event
  belongs_to :inviting_user, class_name: 'User'
  belongs_to :invited_user,  class_name: 'User'

  # FIXME: Copied from user.rb
  VALID_EMAIL_REGEX = /^.+@.+\..+$/ # See http://www.ruby-forum.com/topic/205779
  validates :event,         presence: true
  validates :invited_email, format:   { allow_nil: true,
                                        with:      VALID_EMAIL_REGEX }
  validate :exactly_one_of_invited_user_or_invited_email_is_set

  before_create { generate_token(:token) }

  before_save do |invitation|
    if (!invitation.invited_email.nil?)
      invitation.invited_email = invitation.invited_email.downcase
    end
    if (invitation.invited_user.nil?)
      invitation.invited_user = User.find_by_email(invitation.invited_email)
    end
    if (!invitation.invited_user.nil?)
      invitation.invited_email = nil
    end
  end

  def exactly_one_of_invited_user_or_invited_email_is_set
    if invited_email.nil? && invited_user.nil?
      errors.add(:invited_email, "must be specified if not inviting a user")
    end
    if !invited_email.nil? && !invited_user.nil?
      errors.add(:invited_email, "must not be specified if inviting a user")
    end
  end

  # FIXME: Copied from user.rb, need to consolidate
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while self.class.exists?(column => self[column])
  end
end
