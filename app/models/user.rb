class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation,
                  :password_reset_sent_at
  has_many :sent_invitations,
           foreign_key: 'inviting_user_id',
           class_name: 'Invitation',
           dependent: :destroy
  has_many :received_invitations,
           foreign_key: 'invited_user_id',
           class_name: 'Invitation',
           dependent: :destroy
  has_secure_password

  before_create { generate_token(:remember_token) }
  before_save { |user| user.email = email.downcase }

  VALID_EMAIL_REGEX = /^.+@.+\..+$/ # See http://www.ruby-forum.com/topic/205779
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while self.class.exists?(column => self[column])
  end
end
